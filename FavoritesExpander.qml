import QtQuick 2.1
import QtGraphicalEffects 1.0

Rectangle {
    width: 360; height: 480
    //anchors.margins: 5
    //color: "green"
    //radius: 8
    gradient: Gradient {
        GradientStop {position: 0.0; color: "#353535"}
        GradientStop {position: 1.0; color: "#232323"}
    }
    InnerShadow {
        anchors.fill: parent
        cached: true
        verticalOffset: -3
        radius: 8.0
        samples: 16
        color: "black"
        source: parent
    }
    ListModel {
        id: treemodel
        ListElement {
            text: "Favorites"
            elements: [
                ListElement { text: "All Games"},
                ListElement { text: "Recently Added"},
                ListElement { text: "Top 25 Most Played"},
                ListElement { text: "My Favorites"},
                ListElement { text: "My Zelda Stash"}
            ]
        }
    }
    TreeView { //probably have to turn this into a Component to be Loaded
        anchors.fill: parent
        model: treemodel
    }
}
