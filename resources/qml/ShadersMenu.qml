import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1

    Rectangle {
        id:comboBox
        signal comboClicked;
        color: "#000000FF"
        smooth:true;
        height: 25
        width: 60
        state: "CLOSED"
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
                anchors.margins: 5;
                Keys.onReturnPressed: comboBox.state = "CLOSED"
                model: ShaderModel {}
                delegate:
                    GroupBox {
                        flat: true
                        width: textField.width
                        CheckBox {
                            width: parent.width
                            //text: name
                            style: CheckBoxStyle {
                                label: Label {
                                    text: name
                                    color: "white"
                                    font.bold: true
                                }
                                indicator: Rectangle {
                                    implicitWidth: 14
                                    implicitHeight: 14
                                    border.color: control.activeFocus ? "darkblue" : "gray"
                                    border.width: 1
                                    Rectangle {
                                        visible: control.checked
                                        color: "#cc4d4d"
                                        radius: 1
                                        anchors.margins: 3
                                        anchors.fill: parent
                                    }
                                }
                            }
                        }
                }


            }
        }
        states: State {
            name: "OPEN";
            PropertyChanges { target: dropDown; height: 150 }
        }
        transitions: Transition {
            NumberAnimation { target: dropDown; properties: "height"; easing.type: Easing.OutExpo; duration: 1000 }
        }
    }
