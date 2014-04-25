import QtQuick 2.2
import QtQuick.Controls 1.1

ApplicationWindow {
    height: 115;
    width: 520;
    flags: Qt.Dialog;
    title: "Credit"
    modality: Qt.ApplicationModal;
    TextArea {
        anchors.fill: parent;
        readOnly: true;
        text: "     I would like to say thanks to the whole libretro team for helping me create this frontend\n
and for giving me advice. Also a special thanks to hunterk, AndresSM, SquallDark, and wowzaman12\n
for helping me to test this program out, and for giving me ideas about future additions to the frontend.\n
If you have further questions or wish to contribute to the project you can email me at Druage@gmx.com."

    }
}
