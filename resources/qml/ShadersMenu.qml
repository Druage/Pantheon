import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
import game.launcher 1.0

Rectangle {
    id:comboBox
    signal comboClicked;
    color: "#000000FF"
    smooth:true;
    height: 25
    width: 60
    state: "CLOSED"

    Launcher {id: gameLauncher;}

    Label {
            anchors.centerIn: parent
            color: "white"
            text:"Shaders";
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
            width: 230
            height: 0;
            clip: true;
            anchors.top: comboBox.bottom;
            anchors.horizontalCenter: comboBox.horizontalCenter
            //anchors.margins:  5;
            color: "#2d2d2d"
            ListView {
                id: textField
                anchors.top: parent.top;
                anchors.left: parent.left;
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                Keys.onReturnPressed: comboBox.state = "CLOSED"
                model: ShaderModel {}
                highlight: highlightBar
                delegate:
                    Rectangle {
                    color: "#000000FF"
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 200; height: 25
                    Label {
                        id: label
                        anchors.centerIn: parent
                        text: title
                        font.bold: true
                        color: "white"
                    }
                    states: State {
                        name: "Current"
                        when: wrapper.ListView.isCurrentItem
                        PropertyChanges {target: textField}
                        PropertyChanges {target: label; font.bold: true
                                         opacity: 1.0}
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            textField.currentIndex = index
                            gameLauncher.shader = textField.model.get(textField.currentIndex).path
                            gameLauncher.shader
                            console.log(textField.model.get(textField.currentIndex).path)
                        }
                    }
                }
            }
            Component {
                id: highlightBar
                Rectangle {
                    width: background.width; height: 25
                    anchors.margins: 10
                    y: textField.currentItem.y;
                    color: "#933b3b" //Highlighter Color
                    gradient: Gradient {
                        GradientStop {position: 0.0; color: "#e3c149"}
                        GradientStop {position: 1.0; color: "#e3b100"}
                    }
                }
            }
            ///////////////////////////////////////////////////////////////////////
        }
        states: State {
            name: "OPEN";
            PropertyChanges { target: dropDown; height: 150 }
        }
        transitions: Transition {
            NumberAnimation { target: dropDown; properties: "height"; easing.type: Easing.OutExpo; duration: 1000 }
        }
    }
