from PyQt5.QtCore import pyqtProperty, QCoreApplication, QObject, QUrl
import os, sys

ROOT_DIR = os.path.abspath("..")
PLATFORM = sys.platform

class JoyConfig(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
		if PLATFORM == "win32":
			self._exe = ROOT_DIR + "\\retroarch_v1.0\\retroarch_joyconfig.exe"
		else:
			self._exe = "Not sure will find out"

    @pyqtProperty('QString')
    def exe(self):
        return os.system(self._exe)

    @exe.setter
    def exe(self, exe):
        self._exe = exe