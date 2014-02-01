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
        
def win32_tags(sys_element, core_element, extension):
    if ".sfc" in  extension or ".smc" in extension:
        sys_element.text = "Super Nintendo"
        core_element.text = "bsnes_balanced_libretro.dll"
    elif ".n64" in extension or ".z64" in extension:
        sys_element.text = "Nintendo 64"
        core_element.text = "mupen64plus_libretro.dll"
    elif ".gba" in extension:
        sys_element.text = "Game Boy Advance"
        core_element.text = "vbam_libretro.dll"
    elif ".cue" in extension:
        sys_element.text = "Sony PlayStation"
        core_element.text = "mednafen_psx_libretro.dll"
    elif ".nes" in extension:
        sys_element.text = "Nintendo"
        core_element.text = "nestopia_libretro.dll"
    elif ".gb" in extension:
        sys_element.text = "Game Boy"
        core_element.text = "gambatte_libretro.dll"
    elif ".gbc" in extension:
        sys_element.text = "Game Boy"
        core_elementtext = "gambatte_libretro.dll"
    else:
        sys_element.text = "Unknown"

def linux_tags(sys_element, core_element, extension):
    print(core_element)
    if ".sfc" in  extension or ".smc" in extension:
        sys_element.text = "Super Nintendo"
        core_element.text = "/usr/lib/libretro/bsnes_balanced_libretro.so"
    elif ".n64" in extension or ".z64" in extension:
        sys_element.text = "Nintendo 64"
        core_element.text = "/usr/lib/libretro/mupen64plus_libretro.so"
    elif ".gba" in extension:
        sys_element.text = "Game Boy Advance"
        core_element.text = "/usr/lib/libretro/vbam_libretro.so"
    elif ".cue" in extension:
        sys_element.text = "Sony PlayStation"
        core_element.text = "/usr/lib/libretro/mednafen_psx_libretro.so"
    elif ".nes" in extension:
        sys_element.text = "Nintendo"
        core_element.text = "/usr/lib/libretro/nestopia_libretro.so"
    elif ".gb" in extension:
        sys_element.text = "Game Boy"
        core_element.text = "/usr/lib/libretro/gambatte_libretro.so"
    elif ".gbc" in extension:
        sys_element.text = "Game Boy Color"
        core_element.text = "/usr/lib/libretro/gambatte_libretro.so"
    else:
        sys_element.text = "Unknown"

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

def store_artwork(title_name, art_path, tag):
    """title, path, tag"""
    ofile = ET.parse("games.xml")
    library = ofile.getroot()  
    for game in library:
        for subelement in game:
            if subelement.tag == "title":
                if subelement.text == title_name:
                    image = ET.SubElement(game, tag)
                    image.text = art_path
                    indent(library)
                    ammended_xml = ET.tostring(library).decode("utf-8")
                    with open("games.xml", "w") as new:
                        new.write(ammended_xml)
                    return "Image Added"
        
def xmlreader(file): #Not used yet
        tree = ET.parse(file)
        root = tree.getroot()
        for game in root:
            for title in game:
                print(title.tag)

def xmlwriter(data): #xmlwriter() is loaded automatically after scan is run
        tree = open("games.xml" ,"w")
        tree.write("""<?xml version="1.0"?>\n""")
        root = Element("Library")
        for key, value in sorted(data.items()): #removes extensions for filenames for key values
            game = ET.SubElement(root, "game")
            system = ET.SubElement(game, "system")
            title = ET.SubElement(game, "title")
            path = ET.SubElement(game, "path")
            core = ET.SubElement(game, "core")
            game_extension = key[-4::].lower()
            if PLATFORM == "win32":
                core_ext = ".dll"
                win32_tags(system, core, game_extension)
            else:
                core_ext = ".so"
                linux_tags(system, core, game_extension)
                print(core.text)
            if ".gb" in game_extension:
                clean_key = key.strip(key[-3::])
            else:
                clean_key = key.strip(key[-4::])
            title.text = clean_key
            path.text = '"{:}"'.format(value)
        indent(root) #root doesn't have to be returned
        tree.write(ET.tostring(root).decode("utf-8"))
        tree.close()
        print("Wrote .xml")
