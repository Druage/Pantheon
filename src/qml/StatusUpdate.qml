import QtQuick 2.2
import QtQuick.Controls 1.1

Rectangle {
    id: statusUpdate;
    property string text;
    property bool running: false;

    z: 1;
    visible: false;
    radius: 6;
    width: statusLabel.width + 15;
    height: 25;
    anchors.right: parent.right;
    anchors.top: parent.top;
    anchors.margins: 30;
    color: systemPalette.highlight;

    onTextChanged: {
        if (text !== "") {
            visible = true;
            if (statusTimer.running)
                statusTimer.restart();
            else {
                statusTimer.start();
            }
        }
    }

    Label {
        id: statusLabel;
        anchors.centerIn: parent;
        color: "white";
        onLinkActivated: Qt.openUrlExternally(link);
        text: statusUpdate.text;
        Timer {
            id: statusTimer;
            interval: 5000;
            onTriggered: {
                statusUpdate.text = "";
                statusUpdate.visible = false;
            }
        }
    }
}
