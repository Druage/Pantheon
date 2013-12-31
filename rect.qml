import QtQuick 2.0

Rectangle {
	color: "red"
    signal clicked()
	//Loader {id:load; source: "PlayButton.qml"; anchors.fill: parent }
    MouseArea {
        anchors.fill: parent
        onClicked: {
           parent.clicked()  // emit the parent's signal
        }
    }
}