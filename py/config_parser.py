from PyQt5.QtCore import pyqtProperty, QCoreApplication, QObject, QUrl

class CfgParser(QObject):
    '''read() must be called first'''
    def __init__(self, parent=None):
        super().__init__(parent)
        self._read = ""
        self._parse = ""
        self._libretro_path = ""
        self._libretro_path = ""
        self._system_directory = ""
        self._video_shader_dir = ""
        self._video_fullscreen = ""
        self._video_shader = ""
        self._game_history_path = ""
        
    def read(self):
        with open("retroarch.cfg", "r") as file:
            cfg_data = file.readlines()
        self._read = cfg_data

    def parse(self):

        output = open("new.cfg", "w")
        output.write("".join(cfg_data))

        output.close()
        return self._parse

    def writer(self,):
        
        self._read[0] = self._libretro_path
        self._read[1] = self._libretro_path
        self._read[4] = self._libretro_path
        self._read[19] = self._libretro_path
        self._read[783] = self._libretro_path

        output = open("new.cfg", "w")
        output.write("new.cfg", "w")
        output.close()
            
