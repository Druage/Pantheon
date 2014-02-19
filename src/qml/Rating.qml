import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtGraphicalEffects 1.0

///////////////////////
//Not Implemented Yet//
///////////////////////

Row {
    Rectangle {
        width: 15; height: 15
        color: "#000000FF"
        Image {
            id: first
            source: "images/transparent_blackstar.png"
            sourceSize.width: parent.width; sourceSize.height: parent.height
        }
        MouseArea {
            anchors.fill: first
            hoverEnabled: true;
            onEntered: first.source = "images/blackstar.png"
            onExited: first.source = "images/transparent_blackstar.png"
            onClicked: console.log("1 Star Rating")
            }
    }
    Rectangle {
        width: 15; height: 15
        color: "#000000FF"
        Image {
            id: second
            source: "images/transparent_blackstar.png"
            sourceSize.width: parent.width; sourceSize.height: parent.height
        }
        MouseArea {
            anchors.fill: parent;
            hoverEnabled: true;
            onEntered: first.source = second.source = "images/blackstar.png"
            onExited: first.source = second.source = "images/transparent_blackstar.png"
            onClicked: console.log("2 Star Rating")
        }
    }
    Rectangle {
        width: 15; height: 15
        color: "#000000FF"
        Image {
            id: third
            source: "images/transparent_blackstar.png"
            sourceSize.width: parent.width; sourceSize.height: parent.height
        }
        MouseArea {
            anchors.fill: parent;
            hoverEnabled: true;
            onEntered: first.source = second.source = third.source = "images/blackstar.png"
            onExited: first.source = second.source = third.source = "images/transparent_blackstar.png"
            onClicked: console.log("3 Star Rating")
        }
    }
    Rectangle {
        width: 15; height: 15
        color: "#000000FF"
        Image {
            id: fourth
            source: "images/transparent_blackstar.png"
            sourceSize.width: parent.width; sourceSize.height: parent.height
        }
        MouseArea {
            anchors.fill: parent;
            hoverEnabled: true;
            onEntered: first.source = second.source = third.source = fourth.source = "images/blackstar.png"
            onExited:  first.source = second.source = third.source = fourth.source = "images/transparent_blackstar.png"
            onClicked: console.log("4 Star Rating")
        }
    }
    Rectangle {
        width: 15; height: 15
        color: "#000000FF"
        Image {
            id: fifth
            source: "images/transparent_blackstar.png"
            sourceSize.width: parent.width; sourceSize.height: parent.height
        }
        MouseArea {
            anchors.fill: parent;
            hoverEnabled: true;
            onEntered: first.source = second.source = third.source = fourth.source = fifth.source = "images/blackstar.png"
            onExited: first.source = second.source = third.source = fourth.source = fifth.source = "images/transparent_blackstar.png"
            onClicked: {console.log("5 Star Rating")}
        }
    }
}
