from PyQt5.QtCore import pyqtProperty, QCoreApplication, QObject, QUrl
import xml.etree.ElementTree as ET
from xml.etree.ElementTree import Element
from xml.etree.ElementTree import tostring
import sys

PLATFORM = sys.platform #Check what operating system this is running on for the cores.

class XmlLibrary(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._xmldata = ""

    @pyqtProperty('QString')
    def xmldata(self, data):
        return self._xmldata
    
    @xmldata.setter
    def xmldata(self, data):
        self._xmldata = data
        

def indent(elem, level=0): #Makes xml look super pretty
        i = "\n" + level*"  "
        if len(elem):
            if not elem.text or not elem.text.strip():
                elem.text = i + "  "
            if not elem.tail or not elem.tail.strip():
                elem.tail = i
            for elem in elem:
                indent(elem, level+1)
            if not elem.tail or not elem.tail.strip():
                elem.tail = i
        else:
            if level and (not elem.tail or not elem.tail.strip()):
                elem.tail = i

def xmlreader(file): #Not used yet
        tree = ET.parse(file)
        root = tree.getroot()
        data = []
        for child in root:
            data.append(child.text)
        self._xmlreader = data

def xmlwriter(data): #xmlwriter() is loaded automatically after scan is run
        tree = open("games.xml" ,"w")
        tree.write("""<?xml version="1.0"?>\n""")
        root = Element("Library")
        #print(data.items())
        try:
            for key, value in sorted(data.items()): #removes extensions for filenames for key values
                print(key)
                print(value)
                game = ET.SubElement(root, "game")
                system = ET.SubElement(game, "system")
                title = ET.SubElement(game, "title")
                path = ET.SubElement(game, "path")
                core = ET.SubElement(game, "core")

                extension = key[-4::].lower() #Play it safe for those odd ALL CAPS e.g. (.NES) extensions
                core_ext = ".dll"
                while True:          
                    if PLATFORM == "win32":
                        if ".sfc" in  extension or ".smc" in extension:
                            system.text = "Super Nintendo"
                            core.text = "bsnes_balanced_libretro{:}".format(core_ext)
                            clean_key = key.strip(key[-4::]) #Must fix for .gb files
                        elif ".n64" in extension or ".z64" in extension:
                            system.text = "Nintendo 64"
                            core.text = "mupen64plus_libretro{:}".format(core_ext)
                            clean_key = key.strip(key[-4::])
                        elif ".gba" in extension:
                            system.text = "Game Boy Advance"
                            core.text = "vbam_libretro{:}".format(core_ext)
                            clean_key = key.strip(key[-4::])
                        elif ".cue" in extension:
                            system.text = "Sony PlayStation"
                            core.text = "mednafen_psx_libretro{:}".format(core_ext)
                            clean_key = key.strip(key[-4::])
                        elif ".nes" in extension:
                            system.text = "Nintendo"
                            core.text = "nestopia_libretro{:}".format(core_ext)
                            clean_key = key.strip(key[-4::])
                        elif ".gb" in extension:
                            system.text = "Game Boy"
                            core.text = "gambatte_libretro{:}".format(core_ext)
                            clean_key = key.strip(key[-3::])      
                        elif ".gbc" in extension:
                            system.text = "Game Boy"
                            core.text = "gambatte_libretro{:}".format(core_ext)
                            clean_key = key.strip(key[-4::])
                        else:
                            system.text = "Unknown"
                            clean_key = key.strip(key[-4::])
                        break
                    else:
                        core_ext = ".so"
                        continue
                title.text = clean_key
                path.text = '"{:}"'.format(value)
            
        except:
            return "Error, .xml not generated"
        indent(root) #root doesn't have to be returned
        tree.write(ET.tostring(root).decode("utf-8"))
        tree.close()
        print("Wrote .xml")
