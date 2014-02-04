import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
//import game.launcher 1.0
import QtQuick.XmlListModel 2.0
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.0

Rectangle {
    id:comboBox
    signal comboClicked;
     color: "#000000FF"
    smooth:true;
    height: 25
    width: 60
    state: "CLOSED"
    Label {
        id: shaderLabel
            anchors.centerIn: parent
            color: "white"
            text:"Shaders";
            smooth:true
            font.bold: true
        }
    Image {
        id: expanderImage
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: shaderLabel.right
        source: "../images/expand.png"
        opacity: 0.9
    }
    MouseArea {
        id: mousearea
        width: 400
        height: 30
        anchors.bottomMargin: 0
        anchors.fill: parent;
        onClicked: {
            if (comboBox.state === "CLOSED") {comboBox.state = "OPEN"}
            else {comboBox.state = "CLOSED"}
            }
    }
    states: State {
        name: "OPEN";
        PropertyChanges { target: expanderImage; opacity: 0.7; source: "../images/collapse.png"}
        PropertyChanges { target: dropDown; height: 150 }
    }
    transitions: Transition {
        NumberAnimation {
            target: dropDown
            properties: "height"
            easing.type: Easing.OutExpo
            duration: 1000
        }
    }
    Rectangle {
            id: dropDown
            width: 230
            height: 0;
            clip: true;
            anchors.top: comboBox.bottom;
            //anchors.margins:  5;
            color: "#2d2d2d"
            ColumnLayout {
                anchors.fill: parent
                ListView {
                    id: textField
                    anchors.fill: parent
                    Keys.onReturnPressed: comboBox.state = "CLOSED"
                    highlight: highlightBar
                    model: ShaderModel {}

                    delegate: Rectangle {
                        color: "#000000FF"
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: dropDown.width; height: 25
                        RowLayout {
                            anchors.fill: parent
                            Label {
                                id: label
                                anchors.leftMargin: 15
                                anchors.left: parent.left
                                text: title
                                color: "white"
                            }
                            Rectangle {
                                width: 5; height: 5
                                color: "darkgray"
                                anchors.right: parent.right
                                anchors.rightMargin: 15
                            }
                            states:
                                State {
                                    name: "Current"
                                    when: wrapper.ListView.isCurrentItem
                                PropertyChanges {target: textField}
                                PropertyChanges {target: label;
                                                 font.bold: true
                                                 opacity: 1.0}
                                }
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onMouseYChanged: {
                                    textField.currentIndex = index
                                    //gameLauncher.shader = textField.model.get(textField.currentIndex).path
                                    //gameLauncher.shader
                                    //console.log(textField.model.get(textField.currentIndex).path)
                                }
                            }
                        }
                    }

                }
                DropShadow {
                    source: addShader
                    anchors.fill: source
                    samples: 4
                    radius: 2
                    color: "#80000000"
                    horizontalOffset: 0
                    verticalOffset: -3
                }
                Rectangle {
                    id: addShader
                    width: parent.width
                    height: 25
                    anchors.bottom: parent.bottom
                    color: "#696969"
                    Label {
                        anchors.centerIn: parent
                        text: "+"
                        color: "white"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: fileDialog.open()
                    }
                }
            }
            FileDialog {
                id: fileDialog
                title: "Add A Shader"
                onAccepted: {
                    scanDirectory.directory = fileDialog.fileUrl
                    scanDirectory.scan
                    if (libraryModel.staus !== 1) {
                        libraryModel.reload()
                        console.log("Shader added from qml")
                        console.log("source: ",libraryModel.source)
                    }
                    else {console.log("All is well")}
                }
                onRejected: {console.log("Cancelled"); fileDialog.close()}
            }
            Component {
                id: highlightBar
                Rectangle {
                    width: dropDown.width; height: 25
                    anchors.margins: 10
                    y: textField.currentItem.y;
                    color: "#dedede" //Highlighter Color
                    opacity: 0.1
                }
            }
            ///////////////////////////////////////////////////////////////////////
        }
}
