from PyQt5.QtCore import pyqtProperty, QCoreApplication, QObject, QUrl
from xml_creator import *

import sys, os, fnmatch

xml = XmlLibrary()

class ScanDirectory(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._scan = ""
        self._directory = ""
        self._extensions = ""

    @pyqtProperty('QString')
    def directory(self):
        return self._directory

    @directory.setter
    def directory(self, path):
        if "file:///" in path: #Qt adds this to found files.
            clean = path.strip("file:///")
        else:
            clean = path
        self._directory = clean
        
    @pyqtProperty('QString')
    def extensions(self):
        return self._extensions

    @extensions.setter
    def extensions(self, exts):
        self._extensions = exts

    @pyqtProperty('QString')
    def scan(self):
        if os.path.isfile("games.xml"):
            print("File already exists, please delete the games.xml file and rerun if you wish to reload library data.")
        else:
            matches = {}
            for root, dirnames, filenames in os.walk(self._directory):
                for extension in ("*.sfc", "*.nes", "*.gba", "*.n64", "*.z64","*.cue" ):
                    for filename in fnmatch.filter(filenames, extension):
                        matches[filename] = os.path.join(root, filename)
            self._scan = matches
            xml.data = self._scan
		#xml.data = sorted(xml.data, key= lambda key: xml.data[key]) I will sort it eventually
            xmlwriter(xml.data)

