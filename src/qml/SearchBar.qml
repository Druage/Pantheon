import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

    Rectangle {
        id:comboBox
        signal comboClicked;
        color: "#D7274E"
        smooth:true;
        height: 25
        width: 60
        state: "CLOSED"
        Label {
            //rotation: 180 /* second rotation */
            anchors.centerIn: parent
            id:chosenItemText
            color: "white"
            text:"Search";
            smooth:true
            font.bold: true
        }
            MouseArea {
                id: mousearea
                width: 400
                height: 30
                anchors.bottomMargin: 0
                anchors.fill: parent;
                onClicked: { if (comboBox.state === "CLOSED") {comboBox.state = "OPEN"}
                    else {comboBox.state = "CLOSED"}
                }
                //onQt.Key_Return
            }

        Rectangle {
            id: dropDown
            width: 0
            height: parent.height * 1.7;
            clip: true;
            anchors.left: comboBox.right;
            anchors.verticalCenter: comboBox.verticalCenter
            //anchors.margins:  5;
            color: parent.color
            TextField {
                id: textField
                anchors.top: parent.top;
                anchors.left: parent.left;
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 5;
                Keys.onReturnPressed: comboBox.state = "CLOSED"
            }
        }
        states: State {
            name: "OPEN";
            PropertyChanges { target: dropDown; width: 300 }
        }
        transitions: Transition {
            NumberAnimation { target: dropDown; properties: "width"; easing.type: Easing.OutExpo; duration: 1000 }
        }
    }
