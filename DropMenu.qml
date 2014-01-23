import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Rectangle {
    id:comboBox
    property variant items: ["", "Game Folder: ", "Exe:"]
    signal comboClicked;

    anchors.centerIn: parent
    width: 141
    height: 30;
    smooth:true;
    Rectangle {
        id:chosenItem
        radius: 4;
        width:parent.width;
        height:comboBox.height;
        color: "#454b4d"
        smooth:true;
        Label {
            //rotation: 180 /* second rotation */
            anchors.centerIn: parent
            id:chosenItemText
            x: 11
            y: 5
            color: "#ffffff"
            text:"Video";
            font.family: "Arial"
            font.pointSize: 14;
            smooth:true
        }
            MouseArea {
                width: 400
                height: 30
                anchors.bottomMargin: 0
                anchors.fill: parent;
                onClicked: {
                    comboBox.state = comboBox.state==="dropDown"?"":"dropDown"
                }
            }
        }

        /*Image {
            id: image
            visible: false
            source: "triangle.png";
            width: 25; height: 0
            //clip: true
            anchors.top: chosenItem.bottom
        }*/
        Rectangle {
            id: dropDown
            width: comboBox.width * 2;
            height: 0;
            clip: true;
            radius: 4;
            anchors.top: chosenItem.bottom;
            //anchors.margins:  5;
            color: "#454b4d"
            ListView {
                id:listView
                height: 300;
                model: comboBox.items
                currentIndex: 0
                delegate: Item{
                    //rotation: 180 /* last rotation */
                    width:comboBox.width;
                    height: comboBox.height;
                    RowLayout {
                        //Label {width: 30; height: 100; text: "stuiff"}
                        TextField {
                            text: modelData
                            anchors.top: parent.top;
                            anchors.left: parent.left;
                            anchors.right: parent.right
                            anchors.margins: 5;
                        }
                    }
                }
            }
        }
        states: State {
            name: "dropDown";
            PropertyChanges { target: dropDown; height: 30 * comboBox.items.length }
        }
        transitions: Transition {
            NumberAnimation { target: dropDown; properties: "height"; easing.type: Easing.OutExpo; duration: 1000 }
        }
    }
