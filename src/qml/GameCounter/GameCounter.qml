import QtQuick 2.1
import QtQuick.Controls 1.1

Rectangle {
    id: gameCount
    property string _text
    z: 1
    height: 20
    width: gameCountLabel.contentWidth + 20
    color: systemPalette.highlight
    opacity: 0.1
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: gameCount.opacity = 1.0
        onExited: gameCount.opacity = 0.1
    }

    Label {
        id: gameCountLabel
        anchors.centerIn: parent
        color: "white"
        text: (libraryModel.count === -1) ? 0 : libraryModel.count
    }
}
