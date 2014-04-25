import QtQuick.Controls.Styles 1.1
import QtQuick 2.1
import QtQuick.Controls 1.1

CheckBoxStyle {
    indicator:
        Rectangle {
            implicitWidth: 15
            implicitHeight: 15
            radius: 3
            Rectangle {
                anchors.top: parent.top
                anchors.topMargin: 2
                height: 2
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 5
                color: "#4e4e4e"
                radius: 3

            }

            gradient:
                Gradient {
                    GradientStop {position: 0.0; color: "#343434"}
                    GradientStop {position: 1.0; color: "#242424"}
                }
            border.color: "#000000"//control.activeFocus ? "#000000" : "gray"
            border.width: 2
            Rectangle {
                visible: control.checked
                anchors.centerIn: parent
                color: "red"
                anchors.margins: 3
                anchors.fill: parent
            }
        }
    label:
        Label {
            text: control.text
            color: "#e1e0e0"
        }

}
