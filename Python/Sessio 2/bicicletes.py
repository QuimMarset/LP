
import urllib.request
import xml.etree.ElementTree as ET

url = "http://wservice.viabicing.cat/getstations.php?v=1"
                  
sock = urllib.request.urlopen(url) 
xmlSource = sock.read()                            
sock.close()

root = ET.fromstring(xmlSource)

for estacio in root.findall('station'):
	if (estacio.find('status').text == 'OPN' and estacio.find('type').text == 'BIKE'):
		places = estacio.find('slots').text
		bicicletes = estacio.find('bikes').text
		dif = int(places) - int(bicicletes)
		if dif > 0:
			carrer = estacio.find('street').text
			print("L'estació situada a ", carrer, " té ", bicicletes, "places ocupades i ", dif, " places lliures")