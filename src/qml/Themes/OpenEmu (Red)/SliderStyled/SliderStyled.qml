import QtQuick.Controls.Styles 1.1
import QtQuick 2.1

SliderStyle {
    groove:
        Rectangle {
            implicitWidth: 100
            implicitHeight: 5
            color: "#292929"
            radius: 8
            border.color: "#151515"
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                color: "#3b3b3b"
                height: 1
            }
        }
        handle:
            Rectangle {
                anchors.centerIn: parent
                color: control.pressed ? "white" : "lightgray"
                gradient: Gradient {
                    GradientStop {position: 0.0; color: "#d8d7d7"}
                    GradientStop {position: 1.0; color: "#999999"}
                }

                border.color: "#040404"
                border.width: 1
                width: 14
                height: 14
                radius: 8
            }
}
