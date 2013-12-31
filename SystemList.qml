import QtQuick 2.1
import QtGraphicalEffects 1.0

Rectangle {
    width: 360; height: 480
    //anchors.margins: 20
    //color: "orange"
    //radius: 8
    gradient: Gradient {
        GradientStop {position: 0.0; color: "#353535"}
        //GradientStop {position: 1.0; color: "#232323"}
    }
    /*InnerShadow {
        anchors.fill: parent
        cached: true
        verticalOffset: 3
        horizontalOffset: -3
        radius: 8.0
        samples: 16
        color: "black"
        source: parent
    }*/
    ListModel {
        id: treemodel
        ListElement {
            text: "System"
            elements: [
                ListElement { text: "Nintendo"},
                ListElement { text: "Super Nintendo"},
                ListElement { text: "Nintendo 64"},
                ListElement { text: "Sega Genesis"},
                ListElement { text: "PlayStation"}
            ]
        }
    }
    TreeView {
        anchors.fill: parent
        model: treemodel
    }
}
