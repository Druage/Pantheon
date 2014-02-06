import QtQuick 2.0
import QtQuick.Controls 1.0

Rectangle {
    width: 640
    height: 480


    Button {
        text: qsTr("Input")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        MouseArea {
            anchors.fill: parent
            onClicked: gameLauncher.joy
        }
    }
}
