import urllib.request
import xml.etree.ElementTree as ET
from ast import literal_eval
import argparse
import re
from datetime import datetime
from datetime import timedelta
import math


def missatge_error(cadena):
    return cadena + " no és un argument vàlid"


def paraules_clau(cadena):

    def comprovacio_claus(parametre):
        if isinstance(parametre, str):
            return True
        elif isinstance(parametre, list) or isinstance(parametre, tuple):
            return all([comprovacio_claus(elem) for elem in parametre])
        return False

    parametre = literal_eval(cadena)
    missatge = missatge_error(cadena)
    if not comprovacio_claus(parametre):
        raise argparse.ArgumentTypeError(missatge)
    return parametre


def dates(cadena):

    missatge = missatge_error(cadena)

    regex_data_base = '[0-9]{2}/[0-9]{2}/[0-9]{4}'
    regex_tupla = ('\(\s*' + regex_data_base +
                   '\s*,\s*-?[0-9]+\s*,\s*-?[0-9]+\s*\)')

    matches_tuples = re.findall(regex_tupla, cadena)
    cadena_sense_tuples = re.sub(regex_tupla, '', cadena)
    matches_dates_simples = re.findall(regex_data_base, cadena_sense_tuples)
    cadena_resta = re.sub(regex_data_base, '', cadena_sense_tuples)
    if (re.search('[^\[,\]\s]', cadena_resta) or
            (not matches_tuples and not matches_dates_simples)):
                raise argparse.ArgumentTypeError(missatge)

    def crea_tupla(tupla):
        elements = tupla[1:-1].split(',')
        return (datetime.strptime(elements[0], '%d/%m/%Y'),
                int(elements[1]), int(elements[2]))

    try:
        dates_simples = [datetime.strptime(data, '%d/%m/%Y')
                         for data in matches_dates_simples]
        tuples = [crea_tupla(tupla) for tupla in matches_tuples]
        return dates_simples + tuples
    except ValueError:
        raise argparse.ArgumentTypeError(missatge)


def linies_metro(cadena):

    def comprovacio_linia(linia):
        return bool(re.search('L[0-9]+', linia))

    missatge = missatge_error(cadena)
    cadena = cadena[1:-1]
    elements = cadena.split(',')
    if not all([comprovacio_linia(element) for element in elements]):
        raise argparse.ArgumentTypeError(missatge)
    return elements


def arrel_XML(url):
    socket = urllib.request.urlopen(url)
    xml = socket.read()
    arrel = ET.fromstring(xml)
    socket.close()
    return arrel


def calcula_distancia(lat1, long1, lat2, long2):

    radi_terra = 6371000
    pas_a_rad = math.pi / 180
    phi1 = (90.0 - lat1) * pas_a_rad
    phi2 = (90.0 - lat2) * pas_a_rad
    the1 = long1 * pas_a_rad
    the2 = long2 * pas_a_rad
    val = (math.sin(phi1) *
           math.sin(phi2) * math.cos(the1 - the2) +
           math.cos(phi1) * math.cos(phi2))
    return math.acos(val) * radi_terra


def omple_fila_HTML(estacions, esdeveniment):

    def cerca_estacions_properes(estacions, esdeveniment):
        parells_est_dist = [
            (estacio, calcula_distancia(esdeveniment.latitud,
                                        esdeveniment.longitud,
                                        estacio.latitud, estacio.longitud))
            for estacio in estacions]
        estacions_candidates = sorted(
            [parell for parell in parells_est_dist if parell[1] <= 500],
            key=lambda parell: parell[1])
        return estacions_candidates[0:5]

    def adaptar_edat_esdev(esdeveniment):
        if esdeveniment.edat_esdev == (999, 0):
            return "Edat no especificada"
        elif esdeveniment.edat_esdev[1] == 0:
            return "A partir de  {0} anys".format(esdeveniment.edat_esdev[0])
        else:
            return "De {0} a {1} anys".format(
                esdeveniment.edat_esdev[0], esdeveniment.edat_esdev[1])

    fila = "<tr> <td>" + esdeveniment.nom_esdev + "</td> <td>" \
        + esdeveniment.carrer + ', ' + esdeveniment.numero + ', ' \
        + esdeveniment.municipi + "</td> <td>" \
        + str(esdeveniment.data_ini) + "</td> <td>" \
        + adaptar_edat_esdev(esdeveniment) + "</td>"
    estacions_mes_properes = cerca_estacions_properes(estacions, esdeveniment)
    if estacions_mes_properes:
        for estacio in estacions_mes_properes:
            fila += "<td>" + estacio[0].nom + "</td>"
        return fila
    return ''


def crea_taula_HTML(estacions, esdeveniments):

    fitxer = open('taula.html', 'w')
    header = """<html> <head> <title> Activitats Infantils </title>
        <style> table { width:100%; } table, th, td { border: 1px solid black;
        border-collapse: collapse; } th, td { padding: 5px; text-align: left;
        } </style> </head> <body> <h1> Taula amb les activitats seleccionades
        </h1> <table id = 't01'> <tr> <th> Nom </th> <th> Adreça </th>
        <th> Data i Hora </th> <th> Edat </th> <th colspan = 5> Estacions </th>
        </tr>"""

    fitxer.write(header)
    algun_compleix = False

    for esdeveniment in esdeveniments:
        fila = omple_fila_HTML(estacions, esdeveniment)
        if fila:
            algun_compleix = True
        fitxer.write(fila)

    fitxer.write("</table> </body> </html>")
    if not algun_compleix:
        fitxer.write(
            "No s'han trobat esdeveniments que satisfacin les condicions")
    fitxer.close()


class Esdeveniment:

    def __init__(self, node_esdev):

        self.nom_esdev = node_esdev.findtext('nom')
        self.nom_lloc = node_esdev.findtext('lloc_simple/nom')
        self.barri = node_esdev.findtext('lloc_simple/adreca_simple/barri')
        self.carrer = node_esdev.findtext('lloc_simple/adreca_simple/carrer')
        self.numero = node_esdev.findtext('lloc_simple/adreca_simple/numero')
        self.municipi = node_esdev.findtext(
            'lloc_simple/adreca_simple/municipi')
        self.data_ini = datetime.strptime(node_esdev.findtext(
            'data/data_proper_acte'), '%d/%m/%Y %H.%M')
        self.longitud = node_esdev.find(
            'lloc_simple/adreca_simple/coordenades/googleMaps').get('lon')
        self.latitud = node_esdev.find(
            'lloc_simple/adreca_simple/coordenades/googleMaps').get('lat')
        self.classif_esdev = [
            classif.text for classif in
            node_esdev.findall('classificacions/nivell')]
        self.edat_esdev = self.obtenir_edat()

    def obtenir_edat(self):

        minima_edat = 999
        maxima_edat = 0
        for classif in self.classif_esdev:
            match1 = re.search('de ([0-9]+) a ([0-9]+) anys', classif)
            match2 = re.search('\+ ([0-9]+) anys', classif)
            if match1:
                lim_inf = int(match1.group(1))
                lim_sup = int(match1.group(2))
                if lim_inf < minima_edat:
                    minima_edat = lim_inf
                if lim_sup > maxima_edat:
                    maxima_edat = lim_sup
            elif match2:
                valor = int(match2.group(1)) + 1
                if valor < minima_edat:
                    minima_edat = valor
        return (minima_edat, maxima_edat)

    def valid(self, keys, dates):

        """ Faig el pas a float en aquesta funció ja que
            si no té valors definits no pot ser un esdeveniment vàlid"""
        try:
            self.latitud = float(self.latitud)
            self.longitud = float(self.longitud)
        except ValueError:
            return False
        valid = True
        if dates is not None:
            valid = valid and self.satisfa_dates(dates)
        if valid and keys is not None:
            valid = valid and self.satisfa_keys(keys)
        return valid

    def apte_per_nens(self):

        for classif in self.classif_esdev:
            if "infant" in classif:
                return True
        return (self.edat_esdev != (999, 0) and
                self.edat_esdev[0] < 13 and self.edat_esdev[1] < 13)

    def satisfa_keys(self, keys):

        def normalitza(cadena):
            no_accents = str.maketrans('àáèéíòóú', 'aaeeioou')
            return cadena.lower().translate(no_accents)

        if isinstance(keys, str):
            norm_keys = normalitza(keys)
            return (norm_keys in normalitza(self.nom_esdev) or norm_keys in
                    normalitza(self.nom_lloc) or
                    norm_keys in normalitza(self.barri))
        elif isinstance(keys, list):
            return all([self.satisfa_keys(key) for key in keys])
        elif isinstance(keys, tuple):
            return any([self.satisfa_keys(key) for key in keys])

    def satisfa_dates(self, dates):

        def comprovacio_data(data_esdev, data):
            if isinstance(data, datetime):
                """Es crida a date() per no tenir en compte la hora
                    ja que les dates dels paràmetres no en tenen"""
                return data_esdev.date() == data.date()
            else:
                data_lim_esq = data[0] + timedelta(data[1])
                data_lim_dret = data[0] + timedelta(data[2])
                return (data_esdev.date() >= data_lim_esq.date() and
                        data_esdev.date() <= data_lim_dret.date())

        return any([comprovacio_data(self.data_ini, data) for data in dates])


class Estacio:

    def __init__(self, node_estacio):

        """ El nom s'agafa fins la penúltima perquè hi ha
            un guió al final del nom i no el vull"""
        self.nom = node_estacio.findtext('Tooltip')[0:-1]
        self.latitud = float(node_estacio.findtext('Coord/Latitud'))
        self.longitud = float(node_estacio.findtext('Coord/Longitud'))

    def satisfa_linies(self, linies):

        return any([(lambda linia: linia in self.nom)(linia)
                    for linia in linies])


descripcio_programa = """"Cerca d'activitats infantils per anar
    amb metro amb possibles paràmetres a mode de filtre."""
help_keys = """Consulta construida amb paraules a cercar
    en el nom de l'activitat, del lloc i del barri
    que pot està formada per conjuncions (llista),
    disjuncions (tupla) o bé una sola paraula."""
help_dates = """Llista de dates en format dd/mm/aaaa i un possible
    interval numèric a mode de marge expressat com una tripleta"""
help_metro = """Llista del línies de metro en format L# on # és
    un natural qualsevol."""

if __name__ == '__main__':

    parser = argparse.ArgumentParser(
        description=descripcio_programa, prog='PROG')
    parser.add_argument('--key', '-k', help=help_keys, type=paraules_clau)
    parser.add_argument('--date', '-d', help=help_dates, type=dates)
    parser.add_argument('--metro', '-m', help=help_metro, type=linies_metro)
    args = parser.parse_args()

    url_esdeveniments = \
        "http://w10.bcn.es/APPS/asiasiacache/peticioXmlAsia?id=199"
    url_estacions = ("http://opendata-ajuntament.barcelona.cat/resources/bcn"
                     "/TRANSPORTS GEOXML.xml")
    root_esdev = arrel_XML(url_esdeveniments)
    root_estacions = arrel_XML(url_estacions)

    esdev_candidats = [
            esdev for esdev in list(map(Esdeveniment,
                                        root_esdev.findall('.//acte')))
            if esdev.apte_per_nens() and esdev.valid(args.key, args.date)]

    regex = 'METRO \(L[0-9]+\) - [^\(\)]+-$'
    nodes_est_metro = [node for node in root_estacions.iter('Punt')
                       if re.search(regex, node.findtext('Tooltip'))]
    estacions_candidates = [
        estacio for estacio in list(map(Estacio, nodes_est_metro))
        if args.metro is None or estacio.satisfa_linies(args.metro)]

    crea_taula_HTML(estacions_candidates, esdev_candidats)


"""Donat que de cada estació hi ha varies sortides, per no tenir com les 5 més
    properes 5 sortides de la mateixa estació de metro,només consideraré
    les estacions tals que el nom no conté el carrer on
    hi ha la boca de metro."""

"""També he considerat que si no hi ha cap estació a menys de 500 metres
    no mostraré l'esdeveniment."""

"""Per filtrar les infantils considero a buscar la paraula infant en les
    classificacions i també en busco l'edat. He considerat que infantil
    és fins als 12 anys inclòs."""
