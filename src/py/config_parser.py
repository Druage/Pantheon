from PyQt5.QtCore import pyqtProperty, QCoreApplication, QObject, QUrl
import os, fnmatch

import xml.etree.ElementTree as ET
from xml.etree.ElementTree import Element
from xml.etree.ElementTree import tostring

def scan(directory):
    print(directory)
    matches = {}
    for root, dirnames, filenames in os.walk(directory):
        for extension in ("*.cgp", "*.cg"):
            for filename in fnmatch.filter(filenames, extension):
                matches[filename] = os.path.join(root, filename)
    if len(matches) == 0:
        return "Game files could not be found in the location."
    else:
        print(matches)
            
def read(self):
    with open("retroarch.cfg", "r") as file:
        cfg_data = file.readlines()
    print(cfg_data)

def parse(self):
    output = open("new.cfg", "w")
    output.write("".join(cfg_data))
    output.close()

def xmlwriter(data): #xmlwriter() is loaded automatically after scan is run
    tree = open("Shaders.xml" ,"w")
    tree.write("""<?xml version="1.0"?>\n""")
    root = Element("Library")
    for key, value in sorted(data.items()): #removes extensions for filenames for key values
        title = ET.SubElement(root, "shader")
        path = ET.SubElement(game, "path")
        if ".cg" in key:
            extension = key[-3::].lower()
        else:
            extension = key[-4::].lower()
        clean_key = key.split(extension)
        title.text = key[0]
        path.text = '"{:}"'.format(value)
        indent(root) #root doesn't have to be returned
        tree.write(ET.tostring(root).decode("utf-8"))
        tree.close()
        print("Wrote .xml")
            
