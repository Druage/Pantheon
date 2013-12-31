import QtQuick 2.1
import QtQuick.Controls 1.1
import QtGraphicalEffects 1.0

Rectangle {
    color: "#3f3f3f"
    InnerShadow {
        anchors.fill: parent
        cached: true
        verticalOffset: -1
        //horizontalOffset: 2
        radius: 10
        samples: 16
        color: "black"
        source: parent
    }
    SystemList {
        gradient: Gradient {
            GradientStop {position: 0.0; color: "#353535"}
            GradientStop {position: 1.0; color: "#232323"}
        }
        id: system_list
        anchors.top: parent.top
        anchors.topMargin: 4
        width: parent.width; height:root.height / 3
        anchors.right: parent.right
        anchors.left: parent.left
    }
    FavoritesList {
        gradient: Gradient {
            GradientStop {position: 0.0; color: "#353535"}
            GradientStop {position: 1.0; color: "#232323"}
        }
        id: favorites_list
        anchors.top: system_list.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
    }
}


