    if cadena[0] == '[':
        regex1 = '[0-3][0-9]/[0-1][0-9]/[0-9]{4}'
        regex2 = '\(\s*' + regex1 + '\s*,\s*-?[0-9]\s*,\s*-?[0-9]\s*\)'
        l1 = re.findall(regex2, cadena)
        cadena = re.sub(regex2, '', cadena)
        l2 = re.findall(regex1, cadena)
        llista = l1 + l2
        if not llista:
            raise argparse.ArgumentTypeError(missatgeError)
        return [dates(data) for data in llista]

    elif cadena[0] == '(':
        elements = cadena.split(',')
        try:
            data = datetime.strptime(elements[0][1:], formatData)
            return (data, int(elements[1]), int(elements[2][0:-1]))
        except ValueError:
            raise argparse.ArgumentTypeError(missatgeError)
    else:
        try:
            return datetime.strptime(cadena, formatData)
        except ValueError:
            raise argparse.ArgumentTypeError(missatgeError)