import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

ColumnLayout {
    id: root
    Label {z: 1; anchors.horizontalCenter: parent.horizontalCenter; text: "Currently a Mockup"; font.pixelSize: 24}
    ComboBox {
        id: inputSystemComboBox
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 20
        model: ["Nintendo 64", "Super Nintendo",
                "Bacon", "Cheese", "Pig"]
    }
    GroupBox {
        id: inputGroupBox
        width: 500
        height: 300
        anchors.centerIn: parent
        anchors.top: inputSystemComboBox.bottom
        anchors.bottom: parent.bottom
        anchors.margins: 20
        ColumnLayout {
            anchors.centerIn: parent
            ComboBox {
                model: ["Xbox 360 (Wired)", "Apple",
                        "Orange", "Cocunut", "Tangerine"]
            }
            Label {
                text: "Configure Controller"
                font.bold: true
            }

            Label {
                text: "Digital"
                font.bold: true
            }

            RowLayout {
                Label {text: "Up:"}
                TextField {
                    readOnly: true
                    text: "Hat (Up)"
                }
            }

            RowLayout {
                Label {text: "Left:"}
                TextField {
                    readOnly: true
                    text: "Hat (Left)"
                }
            }

            RowLayout {
                Label {text: "Right:"}
                TextField {
                    readOnly: true
                    text: "Hat (Right)"
                }
            }

            RowLayout {
                Label {text: "Down:"}
                TextField {
                    readOnly: true
                    text: "Hat (Down)"
                }
            }

            Label {
                text: "Analog"
                font.bold: true
            }

            RowLayout {
                Label {text: "Left:"}
                TextField {
                    readOnly: true
                    text: "Axis X-"
                }
            }

            RowLayout {
                Label {text: "Right:"}
                TextField {
                    readOnly: true
                    text: "Axis X+"
                }
            }

            RowLayout {
                Label {text: "Up:"}
                TextField {
                    readOnly: true
                    text: "Axis Y+"
                }
            }

            RowLayout {
                Label {text: "Down:"}
                TextField {
                    readOnly: true
                    text: "Axis Y-"
                }
            }
        }
    }
}
