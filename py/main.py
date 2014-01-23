from PyQt5.QtCore import QUrl
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQuick import QQuickView
from PyQt5.QtQml import qmlRegisterType
from launcher import Launcher
from recursive_scan import ScanDirectory


if __name__ == '__main__':
    import os
    import sys

    app = QGuiApplication(sys.argv)

    view = QQuickView()
    qmlRegisterType(Launcher, 'game.launcher', 1, 0, 'Launcher')
    qmlRegisterType(ScanDirectory, 'game.scan', 1, 0, 'ScanDirectory')
    view.setMinimumHeight(600)
    view.setMinimumWidth(800)
    view.setTitle('RetroArch Phoenix')
    view.setResizeMode(QQuickView.SizeRootObjectToView)
    view.setSource(QUrl.fromLocalFile("../main.qml"))


    view.show()


    sys.exit(app.exec_())
