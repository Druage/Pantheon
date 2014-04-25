import QtQuick 2.2
import QtQuick.Controls 1.1

ApplicationWindow {
    height: 15;
    width: 200;
    flags: Qt.Dialog;
    title: "Contact"
    modality: Qt.ApplicationModal;
    TextField {
        anchors.fill: parent;
        readOnly: true;
        text: "You can email me at Druage@gmx.com."
    }
}
