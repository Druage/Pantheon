import QtQuick 2.0
import QtQuick.Controls 1.0
import QtGraphicalEffects 1.0

Rectangle {
    width: 200; height: 200
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
    SystemExpander {
        id: system_list
        anchors.top: parent.top
        width: parent.width; height:root.height / 3
        anchors.right: parent.right
        anchors.left: parent.left
    }
    FavoritesExpander {
        id: favorites_list
        anchors.top: system_list.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
    }
}


