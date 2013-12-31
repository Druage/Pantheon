import QtQuick 2.0
import QtQuick.Controls 1.0
import QtGraphicalEffects 1.0

//make these images appear automatic with Repeater {}
//add noise to the background

Rectangle {
    width: 500
    height: 500
    color: "gray"
    gradient: Gradient {
        GradientStop {position: 0.0; color: "#323232"}
        GradientStop {position: 1.0; color: "#272727"}
    }
    Flickable {
        anchors.fill: parent
        contentHeight: game_grid.height
        contentWidth: game_grid.width
        boundsBehavior: Flickable.StopAtBounds
    Grid {
        id: game_grid
        anchors.fill: parent
        anchors.margins: 20
        spacing: 50
        Rectangle {
            width: 150; height: 100; color: "red"
            DropShadow {
                anchors.fill: parent
                cached: true
                verticalOffset: 5
                horizontalOffset: 5
                radius: 8
                samples: 16
                color: Qt.rgba(0,0,0, .2 )
                source: parent
            }
            Image {
                anchors.centerIn: parent; source: "images/boxart/army_meny.jpg"
                //fillMode: Image.PreserveAspectCrop
                smooth: true
                width: parent.width ; height: parent.height
                sourceSize.width: 200 ; sourceSize.height: 200
            }
        }
        Rectangle {
            width: 150; height: 100; color: "red"

            Image {
                anchors.centerIn: parent; source: "images/boxart/army_meny.jpg"
                //fillMode: Image.PreserveAspectCrop
                smooth: true
                width: parent.width ; height: parent.height
                sourceSize.width: 200 ; sourceSize.height: 200
            }
        }
        Rectangle {
            width: 150; height: 100; color: "red"
            Image {
                anchors.centerIn: parent; source: "images/boxart/banjo_kazooie.jpg"
                //fillMode: Image.PreserveAspectCrop
                smooth: true
                width: parent.width ; height: parent.height
                sourceSize.width: 200 ; sourceSize.height: 200
            }
        }
        Rectangle {
            width: 150; height: 100; color: "red"
            Image {
                anchors.centerIn: parent; source: "images/boxart/final_fantasy_ii.jpg"
                //fillMode: Image.PreserveAspectCrop
                smooth: true
                width: parent.width ; height: parent.height
                sourceSize.width: 200 ; sourceSize.height: 200
            }
        }
        Rectangle {
            width: 100; height: 100; color: "red"
            Image {
                anchors.centerIn: parent; source: "images/boxart/Zelda 1.jpg"
                //fillMode: Image.PreserveAspectCrop
                smooth: true
                width: parent.width ; height: parent.height
                sourceSize.width: 200 ; sourceSize.height: 200
            }
        }
        Rectangle {
            width: 100; height: 100; color: "red"
            Image {
                anchors.centerIn: parent; source: "images/boxart/Zelda 2 Re-Release.jpg"
                //fillMode: Image.PreserveAspectCrop
                smooth: true
                width: parent.width ; height: parent.height
                sourceSize.width: 200 ; sourceSize.height: 200
                }
            }
        }
    }
}

