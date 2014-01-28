import QtQuick 2.1
import QtQuick.Controls 1.1

ApplicationWindow {
    width: 360
    height: 360
    menuBar: MenuBar {
        Menu {title: "File"
            MenuItem {text: "hello"}
        }

    }

    Text {
        anchors.centerIn: parent
        text: "Hello World"
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            Qt.quit();
        }
    }
}

