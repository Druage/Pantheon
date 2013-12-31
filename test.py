#Sample Python File
from PyQt5.QtCore import QUrl
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQuick import QQuickView

if __name__ == '__main__':
    import os
    import sys

    app = QGuiApplication(sys.argv)

    view = QQuickView()
    view.setWidth(500)
    view.setHeight(500)
    view.setTitle('Hello PyQt')
    view.setResizeMode(QQuickView.SizeRootObjectToView)
    view.setSource(QUrl.fromLocalFile('main.qml'))


    def on_qml_mouse_clicked(mouse_event):
        print ('mouse clicked')

    view.show()
    qml_rectangle = view.rootObject()

    # this technique doesn't work #############################
    #qml_rectangle.clicked.connect(on_qml_mouse_clicked)
    sys.exit(app.exec_())
