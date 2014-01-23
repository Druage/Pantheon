from xml.etree import ElementTree as ET

NEWDATA = ['C:/Users/leealis/Desktop/Emulation/SNES\\ChronoTrigger(USA).sfc', \
                'C:/Users/leealis/Desktop/Emulation/SNES\\Contra III - The Alien Wars (USA).sfc', \
                'C:/Users/leealis/Desktop/Emulation/SNES\\EarthBound (USA).sfc', \
                'C:/Users/leealis/Desktop/Emulation/SNES\\FinalFantasyIII(USA).sfc', \
                'C:/Users/leealis/Desktop/Emulation/SNES\\Legend of Zelda, The - A Link to the Past (USA).sfc', \
                'C:/Users/leealis/Desktop/Emulation/SNES\\SecretofMana.sfc', \
                'C:/Users/leealis/Desktop/Emulation/SNES\\Super Mario RPG - Legend of the Seven Stars (USA).sfc', \
                "C:/Users/leealis/Desktop/Emulation/SNES\\Super Mario World 2 - Yoshi's Island (USA).sfc", \
                'C:/Users/leealis/Desktop/Emulation/SNES\\SuperMarioAll-Stars(USA).sfc']


def xmlParse():
	tree = ET.parse("roms.xml")
	root = tree.getroot()
	
	data = {}
	for child in root:
		if "input" in child.tag:
			pass
		else:	
			text = child.text.strip('"')
			data[child.tag] = text
	return data


def xmlWriter(data, xmlObj):
        counter = 0
        while counter < len(data):
                xmlObj.text = str(data[counter])
                counter += 1
        return tree.write("roms.xml")
       
        
                
tree = ET.parse("roms.xml")
root = tree.getroot()
sub = ET.SubElement(root, "file")
xmlWriter(NEWDATA, sub)
