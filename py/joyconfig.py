from PyQt5.QtCore import pyqtProperty, QCoreApplication, QObject, QUrl
import os, sys

ROOT_DIR = os.path.abspath("..")
PLATFORM = sys.platform

class JoyConfig(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._exe = "retroarch_joyconfig.exe"

    @pyqtProperty('QString')
    def exe(self):
        return os.system(ROOT_DIR + "\\retroarch_v1.0\\" + self._exe)
	
    @exe.setter
    def exe(self, exe):
        self._exe = exe
