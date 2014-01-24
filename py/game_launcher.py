from PyQt5.QtCore import pyqtProperty, QCoreApplication, QObject, QUrl
import os, subprocess, sys

STARTUP_INFO = subprocess.STARTUPINFO()
PLATFORM = sys.platform
ROOT_DIR = os.path.realpath(os.path.dirname(sys.argv[0]))

class Launcher(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        if PLATFORM == "win32":
            self._exe = ROOT_DIR + "\\retroarch_v1.0\\retroarch.exe"
            self._joy = "retroarch-joyconfig.exe"
        else:
            self._exe = "/usr/bin/retroarch"
            self._joy = "retroarch-joyconfig" #Not sure if this is correct, will check
        self._path = ""
        self._core = ""
        self._launch = self._exe + " " + self._core + " " + self._path
        

    @pyqtProperty('QString')
    def joy(self):
        return os.system(ROOT_DIR + "\\retroarch_v1.0\\" + self._joy)

    @joy.setter
    def joy(self, joy):
        self._joy = joy
        
    @pyqtProperty('QString')
    def exe(self):
        return self._exe

    @exe.setter
    def exe(self, exe):
        self._exe = exe

    @pyqtProperty('QString')
    def path(self):
        return self._path

    @path.setter
    def path(self, path):
        if "file:///" in path:
            clean = path.strip("file:///")
        else:
            clean = path
        self._path = clean
        
    @pyqtProperty('QString')    
    def core(self):
        return self._core

    @core.setter
    def core(self, core):
        if PLATFORM == "win32":
            self._core = "-L " + ROOT_DIR + "\\retroarch_v1.0\\libretro\\" + core
        else:
            self._core = "-L " + ROOT_DIR + "/retroarch_v1.0/libretro/" + core

    @pyqtProperty('QString')    
    def launch(self):
        self._launch = self._exe + " " + self._core + " " + self._path 
        print(self._launch)
        STARTUP_INFO.dwFlags |= subprocess.STARTF_USESHOWWINDOW #hides terminal from showing
        return subprocess.call(self._launch, startupinfo=STARTUP_INFO)
