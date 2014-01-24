#!/usr/bin/env python3
from PyQt5.QtCore import QUrl
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQuick import QQuickView
from PyQt5.QtQml import qmlRegisterType

import os, sys

lib_path = os.path.realpath(os.path.dirname(sys.argv[0]))
sys.path.append(lib_path + "/py")

from game_launcher import Launcher
from game_scan import ScanDirectory

if __name__ == '__main__':

    app = QGuiApplication(sys.argv)

    view = QQuickView()
    qmlRegisterType(Launcher, 'game.launcher', 1, 0, 'Launcher')
    qmlRegisterType(ScanDirectory, 'game.scan', 1, 0, 'ScanDirectory')
    view.setMinimumHeight(600)
    view.setMinimumWidth(800)
    view.setTitle('RetroArch Phoenix')
    view.setResizeMode(QQuickView.SizeRootObjectToView)
    view.setSource(QUrl.fromLocalFile(lib_path + "/qml/main.qml"))

    view.show()

    sys.exit(app.exec_())
