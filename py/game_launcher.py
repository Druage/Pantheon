from PyQt5.QtCore import pyqtProperty, QCoreApplication, QObject, QUrl
import os, subprocess, sys

PLATFORM = sys.platform
ROOT_DIR = os.path.realpath(os.path.dirname(sys.argv[0]))
if PLATFORM == "win32":
    STARTUP_INFO = subprocess.STARTUPINFO()
    STARTUP_INFO.dwFlags |= subprocess.STARTF_USESHOWWINDOW

class Launcher(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        if PLATFORM == "win32":
            self._exe = ROOT_DIR + "\\retroarch_v1.0\\retroarch.exe"
            self._joy = "retroarch-joyconfig.exe"
        else:
            self._exe = "/usr/bin/retroarch"
            self._joy = "/usr/bin/retroarch-joyconfig" #Not sure if this is correct, will check
        self._path = ""
        self._core = ""
        self._launch = self._exe + " " + self._core + " " + self._path
        self._fullscreen = " -f --menu "
        

    @pyqtProperty('QString')
    def joy(self):
        if PLATFORM == "win32":
            joy_path = ROOT_DIR + "\\retroarch_v1.0\\" + self._joy
        else:
            joy_path = "/usr/bin/retroarch-joyconfig"
        return os.system(joy_path)

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
            self._core = "-L " + core

    @pyqtProperty('QString')    
    def launch(self):
        self._launch = self._exe + " " + self._core + " " + self._path 
        print(self._launch)
        if PLATFORM == "win32":
             #hides terminal from showing
            return subprocess.call(self._launch, startupinfo=STARTUP_INFO)
        else:
            os.system(self._launch)

    @pyqtProperty('QString')
    def fullscreen(self):
        if PLATFORM == "win32":
            return subprocess.call(self._exe + self._fullscreen, startupinfo=STARTUP_INFO)
        else:
            return os.system(self._exe + self._fullscreen)
