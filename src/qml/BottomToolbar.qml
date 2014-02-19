import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.0

Rectangle {
    property alias bottomToolbar: bottomToolbar
    id: bottomToolbar
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 35
    width: parent.width
    gradient: Gradient {
        GradientStop {position: 0.0; color: "#696969"}
        GradientStop {position: 0.5; color: "#5f5f5f"}
        GradientStop {position: 1.0; color: "#595959"}
    }
     RowLayout {
        anchors.fill: parent
        Rectangle {
            id: plusButton
            //anchors.left: searchBar.right
            anchors.leftMargin: 15
            anchors.left: parent.left
            color: "#000000FF"
            implicitHeight: bottomToolbar.height * 0.7; implicitWidth:  plusButton.height
            Image {id: plusImage; anchors.fill: parent; source: "../images/folder_plus.png"}
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {fileDialog.open(); console.log(libraryModel.status)}
            }
            DropShadow {
                source: plusImage
                anchors.fill: source
                samples: 4
                radius: 2
                color: "#80000000"
                horizontalOffset: 1
                verticalOffset: 1
            }
            FileDialog {
                id: fileDialog
                title: "Find Folder Containing Games"
                selectFolder: true
                onAccepted: {
                    scanDirectory.directory = fileDialog.fileUrl
                    scanDirectory.scan

                    if (libraryModel.staus !== 1) {
                        libraryModel.reload()
                        console.log(".xml loaded correctly.")
                        console.log("source: ",libraryModel.source)
                    }
                    else {console.log("All is well")}
                }
                onRejected: {console.log("Cancelled"); fileDialog.close()}
            }
        }
        Rectangle {
            id: playButton
            height: plusButton.width; width: plusButton.width
            implicitHeight: bottomToolbar.height * 0.7; implicitWidth:  plusButton.height
            color: "#000000FF"
            Image {id: playImage; anchors.fill: parent; source: "../images/play.png"}
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: gameLauncher.launch
            }
            DropShadow {
               source: playImage
               anchors.fill: source
               samples: 4
               radius: 2
               color: "#80000000"
               horizontalOffset: 1
               verticalOffset: 1
            }
        }
        Rectangle {
            id: gridButton
            width: 25; height: 25
            color: "#000000FF"
            Image {
                id: gridImage
                anchors.fill: parent
                source: "../images/grid.png"
            }
            DropShadow {
                source: gridImage
                anchors.fill: source
                samples: 4
                radius: 2
                color: "#80000000"
                horizontalOffset: 1
                verticalOffset: 1
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                function switchViews() { // Put in separate .js file
                    if (gridButton.state === "clicked") {
                        stackView.push(componentGrid)
                    }
                    else {stackView.push(gameTable)}
                }
                onClicked: {
                    gridButton.state === "clicked" ? gridButton.state = "" : gridButton.state = "clicked"
                    switchViews()
                }
            }
        }
        Rectangle {
            id: fullscreenButton
            width: 25; height: 25
            color: "#000000FF"
            Image {
                id: fullscreenImage
                anchors.fill: parent
                source:"../images/fullscreen.png"
            }
            DropShadow {
                source: fullscreenImage
                anchors.fill: source
                samples: 4
                radius: 2
                color: "#80000000"
                horizontalOffset: 2
                verticalOffset: 2
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: gameLauncher.fullscreen
            }
        }
        Slider { //Controls gameGrid icon size
            property alias slider: slider
            id: slider
            property int value: 75
            //value: 75
            minimumValue: 1; maximumValue: 150
            width: bottomToolbar.width / 6
            anchors.right: parent.right
            anchors.rightMargin: 20
            style:
                SliderStyle {
                    groove: Rectangle {
                        radius: 8
                        implicitHeight: 5
                        color: "lightgray"
                    }
                    handle: Rectangle {
                        radius: 8
                        implicitWidth: 15 ;implicitHeight: 15
                        color: "aqua"
                    }
                }
        }
    }
}
