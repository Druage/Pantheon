import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1


Component {
        id: settings
        Item {
        Rectangle{
            anchors.fill: parent;
            color: "lightyellow"
            ColumnLayout {
                anchors.fill: parent
                Rectangle {
                    id: menuBar;
                    anchors.top: parent.top;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    height: 50;
                    color: "gray"
                    ToolButton {
                        text: "<--"; anchors.verticalCenter: parent.verticalCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: stackView.p
                        }
                    }
                }
                RowLayout {
                    anchors.top: menuBar.bottom
                    anchors.bottom: parent.bottom
                    Label { width: 100; height: 50; text: "Retroarch Exe:"}
                    TextField {id: textField; width: 200; height: 50}
                }
            }

        }
        }
    }