from PyQt5.QtCore import pyqtProperty, QCoreApplication, QObject, QUrl
from xmlparser import *

import sys, os, fnmatch

ROOT_DIR = os.path.abspath("..")
xml = XmlLibrary()

class ScanDirectory(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._scan = "Must get directory first"
        self._directory = "Add a directory"
        self._extensions = ["*.sfc", "*.nes", "*.gba"]
        #self._data = "Must run scan first"
        #self._iterate_data = "Must get data first"

    @pyqtProperty('QString') #Get this to print itself out
    def directory(self):
        return self._directory

    @directory.setter
    def directory(self, path):
        if "file:///" in path:
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
        matches = {}
        for root, dirnames, filenames in os.walk(self._directory):
            for extension in ("*.sfc", "*.nes", "*.gba", "*.n64", "*.z64","*.cue" ):
                for filename in fnmatch.filter(filenames, extension):
                    matches[filename] = os.path.join(root, filename)
        self._scan = matches
        xml.data = self._scan
        #xml.data = sorted(xml.data, key= lambda key: xml.data[key]) i will sort it eventually
        xmlwriter(xml.data)

