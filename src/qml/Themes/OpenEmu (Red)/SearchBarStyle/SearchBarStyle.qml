import QtQuick.Controls.Styles 1.1
import QtQuick 2.1
import QtQuick.Controls 1.1


TextFieldStyle {
    textColor: "#e1e0e0"
    placeholderTextColor: "#e1e0e0"
    padding.left: 20

    background:
        Rectangle {
            radius: 12
            implicitWidth: 100
            implicitHeight: 20
            border.color: "#1b1b1b"
            border.width: 1
            gradient: Gradient {
                GradientStop {position: 0.0; color: "#222222"}
                GradientStop {position: 5.0; color: "#2a2a2a"}
                GradientStop {position: 1.0; color: "#2c2c2c"}
            }
            Rectangle {
                anchors.bottom: parent.bottom
                //anchors.bottomMargin: 1
                width: parent.width - 20
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#434343"
                height: 1
                radius: 1
                opacity: 0.54
            }
        }
}
