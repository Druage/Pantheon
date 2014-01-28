#Currently doesn't build correctly, I believe the main.py cannot find the qml files.

import os, sys
from cx_Freeze import setup, Executable

path_platforms = ( "C:\Python33\Lib\site-packages\PyQt5\plugins\platforms\qwindows.dll", "platforms\qwindows.dll")

include_paths = ("C:\\Users\\leealis\\Desktop\\RetroarchPhoenix","\\RetroarchPhoenix\\qml")

includes = ["PyQt5.QtCore","PyQt5.QtGui", "PyQt5.QtWidgets","PyQt5.QtQuick" ,"PyQt5.QtQml", "PyQt5.QtNetwork"]
includefiles = [path_platforms, "qml" , "js", "images", "py", "retroarch_v1.0"]

excludes = [
    '_gtkagg', '_tkagg', 'bsddb', 'curses', 'email', 'pywin.debugger',
    'pywin.debugger.dbgcon', 'pywin.dialogs', 'tcl',
    'Tkconstants', 'Tkinter'
]
packages = ["os", "subprocess", "xml.etree", "xml.etree.ElementTree", "fnmatch"]

path = []
create_shared_zip = True
# Dependencies are automatically detected, but it might need fine tuning.
build_exe_options = {
                     "includes":      includes, 
                     "include_files": includefiles,
                     "excludes":      excludes, 
                     "packages":      packages, 
                     "path":          path
                     #"zip_includes": include_paths
}

# GUI applications require a different base on Windows (the default is for a
# console application).
base = None
exe = None
if sys.platform == "win32":
    exe = Executable(
      script="C:\\Users\\leealis\\Desktop\\RetroarchPhoenix\\main.py",
      initScript = None,
      base="Win32GUI",
      targetName="phoenix-retroarch.exe",
      compress = True,
      copyDependentFiles = True,
      appendScriptToExe = False,
      appendScriptToLibrary = False,
      #icon = "C:\\Users\\leealis\\Desktop\\Frontend\\phoenix.png"
    )

setup(  
      name = "RetroArch Phoenix",
      version = "0.1",
      author = 'Druage (or Lee)',
      description = "The Rebirth of a Desktop U.I.",
      options = {"build_exe": build_exe_options},
      executables = [exe]
)
