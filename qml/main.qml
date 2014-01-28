import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.1
import QtQuick.XmlListModel 2.0
import QtQuick.Dialogs 1.0

import game.launcher 1.0
import game.scan 1.0
import "../js/appendModel.js" as AppendModel

//ON RIGHT CLICK IN GRIDVIEW BRING UP GAME DATA

Rectangle {
    id: root
    width: 1024
    height: 768

    Launcher {id: gameLauncher;}
    ScanDirectory {id: scanDirectory;}



    Rectangle {
        id: gameLayout
        anchors.top: parent.top
        anchors.bottom: settings.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        /////////////////////////////////////////////////////
        /////////          System List             //////////
        /////////////////////////////////////////////////////
        ColumnLayout {
            id: leftColumn
            //z: gameTable.z + 1
            anchors.top: parent.top
            width: 250;
            anchors.bottom: parent.bottom
            state:  "ON"

            Rectangle {
                id: leftSide
                anchors.top: parent.top
                width: leftColumn.width; height: root.height * 0.65
                color: "#383838"//Controls background color
                TextField {
                    id: searchBar
                    width: 200; height: 28
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 25
                    Keys.onReturnPressed: searchBar.state = "CLOSED"
                    textColor: "white"
                    placeholderText: "Search..."
                    Timer{
                        id: filterTimer
                        interval:500
                        running: false
                        repeat: false
                        onTriggered: {
                            console.log("triggered");
                            libraryModel.query = "/Library/game[contains(lower-case(child::title),lower-case(\""+searchBar.text+"\"))]";
                            libraryModel.reload();
                        }
                    }//Timer
                    onTextChanged:{
                        console.log(searchBar.text);
                        if (filterTimer.running) { console.log("restarted"); filterTimer.restart() }
                        else { console.log("started"); filterTimer.start() }
                    }
                    style: TextFieldStyle {
                        background: Rectangle {
                            color: "#777373"
                            border.pixelAligned: Qt.Vertical
                            border.color: "#838383"
                        }
                        placeholderTextColor: "white"
                    }
                }
               /* InnerShadow {
                    anchors.fill: source
                    source: searchBar
                    visible: true
                    horizontalOffset: -1
                    verticalOffset: -1
                    radius: 1
                    samples: 2
                    color: "#80000000"
                }*/

                Rectangle {
                    id: header
                    width: 250;
                    height: 25
                    anchors.top: searchBar.bottom
                    anchors.left: parent.left
                    anchors.topMargin: 10
                    anchors.right: parent.right
                    color: "#000000FF"
                    radius: 2
                    state: "ON"
                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        text: "<b>System</b>"
                        color: "white"
                    }
                    InnerShadow {
                        id: headerShadow
                        anchors.fill: header
                        visible: false
                        horizontalOffset: -1
                        verticalOffset: -1
                        radius: 8
                        samples: 16
                        color: "#80000000"
                        source: header
                    }
                }
                Rectangle {
                    id: background
                    height: filterMenu.contentHeight
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: header.bottom
                    color: "#000000FF"
                    //////////////////////////////////////////////////
                    Component {
                        id: highlightBar
                        Rectangle {
                            width: background.width; height: 25
                            y: filterMenu.currentItem.y;
                            color: "#933b3b" //Highlighter Color
                            gradient: Gradient {
                                GradientStop {position: 0.0; color: "#cc4d4d"}
                                GradientStop{position: 0.5; color: "#ad4141"}
                                GradientStop {position: 1.0; color: "#933b3b"}
                            }

                            anchors.margins: 10
                        }
                    }
                    //////////////////////////////////////////////////
                ListView {
                    id: filterMenu
                    anchors.fill: parent
                    focus: true
                    highlightFollowsCurrentItem: false
                    highlight: highlightBar
                    interactive: false
                    model: SystemModel {}
                    delegate: Rectangle {
                        id: wrapper
                        width: filterMenu.width; height: 25
                        color: "#000000FF"
                        states: State {
                            name: "Current"
                            when: wrapper.ListView.isCurrentItem
                            PropertyChanges { target: wrapper; //x: -40
                            }
                            PropertyChanges { target: label; font.bold: true; opacity: 1.0
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            function filter () {
                                if (label.text === "All") {
                                    libraryModel.query = "/Library/game[*]"; // * displays all nodes
                                    libraryModel.reload()
                                }
                                else {
                                    libraryModel.query = "/Library/game[contains(lower-case(child::system),lower-case(\""+label.text+"\"))]";
                                    libraryModel.reload()
                                }
                            }
                            onClicked: {filterMenu.currentIndex = index; filter()}
                        }
                        Label {id: label;
                            anchors.verticalCenter: parent.verticalCenter;
                            text: name;
                            opacity: 0.5
                            color: "white";
                            x: 50
                        }
                    }   // Delegate
                }       // ListView; id: filterMenu
            }           // Rectangle; id: background
        }
            Rectangle {
                anchors.top: leftSide.bottom
                anchors.bottom: parent.bottom
                height: 50; width: parent.width
                color: "#383838"
                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: "Settings"
                    color: "white"
                }
            }
        }//Rectangle: leftSide
        InnerShadow {
            anchors.fill:source
            source: leftColumn
            horizontalOffset: -1
            verticalOffset: -1
            radius: 8
            samples: 16
            color: "#80000000"

        }

        //////////////////////////////////////////////////////////////////
        /////////               Game Table View                  /////////
        //////////////////////////////////////////////////////////////////
    StackView {
        id: stackView
        anchors.top: parent.top
        anchors.bottom: parent.bttom
        anchors.left: leftColumn.right
        anchors.right: parent.right
        initialItem: gameTable
        TableView {
            id: gameTable
            highlightOnFocus: true
            backgroundVisible: true
            model: LibraryModel {id: libraryModel}
            onClicked: {
                gameLauncher.core = gameTable.model.get(gameTable.currentRow).core;
                gameLauncher.path = gameTable.model.get(gameTable.currentRow).path
            }
            onDoubleClicked: gameLauncher.launch
            headerDelegate: Rectangle {
                height: 25;
                color: leftSide.color
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: styleData.value
                    color: "white"
                    font.bold: true
                    x: 13
                }
            }
            rowDelegate: Rectangle {
                height: 25; color: styleData.selected ?  "#cc4d4d" : "#E4E7E9"
            }

            itemDelegate: Item {
                    Label  {
						x: 12
						width: Text.contentWidth
						anchors.verticalCenter: parent.verticalCenter
						text: styleData.value
						color: "#29070F"
						elide: Text.ElideRight
						font.bold: true
                        font.pixelSize: 11
					}
			}
            style: TableViewStyle {
               frame: Rectangle {
                    color: leftSide.color
                }
            }
            TableViewColumn{ role: "title"; title: "Name"; width: 400 }
            /*TableViewColumn{ //Rating system is not yet implemented
                role: "rating"
                title: "Rating"
                width: 100
                delegate: Item {
                    width: 100; height: 15
                    Loader{
                        id: rating_img
                        anchors.verticalCenter: parent.verticalCenter
                        source: styleData.value
                    }
                }
            }*/
            TableViewColumn{ role: "system"; title: "System"; width: 200 }
            TableViewColumn{ role: "core"; title: "Core"; width: 200 }
        }
    }
    //////////////////////////////////////////////////////////////////
    /////////               Game Cover Art Grid              /////////
    //////////////////////////////////////////////////////////////////
    Component {
        id: componentGrid
        Rectangle {
            id: gameGrid
            width: 800; height: 600
            color: "#2b2b2b" //Grid Background Color
            visible: true
            z: -1
            Image {
                anchors.fill: parent;
                source: "../images/noise.png"
            }
            GridView {
                id: gameView
                anchors.fill: parent
                anchors.margins: 20
                //: 5
                cellHeight: 250 + slider.value * 2
                cellWidth: 190 + slider.value * 2
                focus: true
                highlight: gameHighlighter
                model: libraryModel
                delegate: gameDelegate
            ////////////////////////////////////////////////////
            Component {
                id: gameHighlighter
                Rectangle {
                    opacity: 0.5
                    color: "white" //Highlighter Color

                    height: 20; width: 20
                    y: gameView.currentItem.y;
                }
            }
            ////////////////////////////////////////////////////
            Component {
                id: gameDelegate
                Rectangle {
                    width: 200 + slider.value * 2;
                    height: 250 +  slider.value * 2
                    color: "#2b2b2b"//gameGrid.color
                    id: gameFrame
                    states: State {
                        name: "Current"
                        when: gameList.ListView.isCurrentItem
                    }
                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width * 0.8; height: parent.height * 0.8
                        color: "#000000FF"
                        Rectangle {
                            id: gameRectangle
                            color: "#000000FF"
                            width: parent.width * 0.7; height: parent.height * 0.7
                            anchors.centerIn: parent
                            Image {
                                id: gameImage
                                source: "../images/tv_color_bars.jpg"
                                anchors.centerIn: parent; //source: portrait
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                width: parent.width  ; height: parent.height
                                sourceSize.width: 500 ; sourceSize.height: 500

                            }
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                onDoubleClicked: gameLauncher.launch
                                onClicked:
                                    if (mouse.button === Qt.RightButton){
                                        rightClickMenu.popup()}
                                    else {
                                         gameView.currentIndex = index;
                                         gameLauncher.core = gameView.model.get(gameView.currentIndex).core;
                                         gameLauncher.path = gameView.model.get(gameView.currentIndex).path
                                    }

                            }
                            // Adds game artwork to individual game
                            FileDialog {
                                id: artworkDialog
                                title: "Find Artwork"
                                onAccepted: {
                                    console.log(artworkDialog.fileUrl)
                                    gameImage.source = artworkDialog.fileUrl
                                    artworkDialog.close()
                                }
                                onRejected: {
                                   console.log("Cancelled")
                                   fileDialog.close()
                                }
                            }

                            Menu {
                                id: rightClickMenu
                                title: "Edit"

                                MenuItem {
                                    text: "Add Artwork"
                                    onTriggered: artworkDialog.open()
                                }
                            }



                        /*DropShadow{               // Currently resizing grid
                            id: gameShadow          // takes down performance
                            //cached: true          // because shadow has to be
                            fast: true              // redrawn everytime
                            transparentBorder: true
                            enabled: false
                            anchors.fill: source
                            source: gameRectangle
                            radius: 2
                            samples: 4
                            color: "#80000000"
                            verticalOffset: 5
                            horizontalOffset: 5
                            }*/
                        Label {
                            text: title
                            font.bold: true
                            font.pixelSize: 14
                            color: "white"
                            width: parent.width
                            anchors.top: gameRectangle.bottom
                            anchors.topMargin: 10
                            elide: Text.ElideRight
                            horizontalAlignment:  Text.AlignHCenter
                        }
                        }
                    }
                }
            }
            }
        }//ListView
    }//Component; id: componentGrid
    }
    //////////////////////////////////////////////////////////////////
    /////////              Advanced Settings                //////////
    //////////////////////////////////////////////////////////////////
    Rectangle {
        anchors.bottom: bottomToolbar.top
        id: settings
        width: parent.width
        height: 0
        rotation: 180
        states: [
            State {
                name: "clicked"
                PropertyChanges { target: settings; height: 100 }
                PropertyChanges { target: topMenu; enabled: true }
                PropertyChanges { target: settingsButton; visible: true }
            }
        ]
        transitions: Transition {
            PropertyAnimation {property: "height"; easing.type: Easing.OutQuad}
        }
        RowLayout {
            id: topMenu
            anchors.fill: parent
            enabled: false
            rotation: 180
            //Button {id: settingsButton; visible: false; text:
            //"Advanced Settings"; onClicked: stackView.push(advancedSettings)}
            //Button {visible: settingsButton.visible; text: "
            //Cores"; onClicked: stackView.push(cores)}
            //Button {visible: settingsButton.visible; tex
            //t: "Library Paths"; onClicked: stackView.push(libraryPaths)}
        }
    }
    //////////////////////////////////////////////////////////////////
    /////////               Bottom Toolbar                  //////////
    //////////////////////////////////////////////////////////////////
    Rectangle {
     id: bottomToolbar
     //anchors.top: settings.bottom
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
         ToolButton {
             id: plusButton
             //anchors.left: searchBar.right
             anchors.leftMargin: 15
             iconSource: "../images/plus.png"
             implicitHeight: bottomToolbar.height * 0.7; implicitWidth:  plusButton.height
             MouseArea {
                 anchors.fill: parent
                 hoverEnabled: true
                 onClicked: {
                     fileDialog.open()
                     console.log(libraryModel.status)
                 }
             }
             FileDialog {
                 id: fileDialog
                 title: "Find Folder Containing Games"
                 selectFolder: true
                 onAccepted: {
                     scanDirectory.directory = fileDialog.fileUrl
                     scanDirectory.scan
                     if (libraryModel.staus !== 1) {
                         libraryModel.reload(); console.log(".xml loaded correctly.") //Reloads .xml file in model
                     }
                     else {console.log("All is well")}
                 }
                 onRejected: {
                    console.log("Cancelled")
                    fileDialog.close()
                 }
             }
         }
         ToolButton {
             id: playButton
             height: plusButton.width; width: plusButton.width
             iconSource: "../images/play.png"
             implicitHeight: bottomToolbar.height * 0.7; implicitWidth:  plusButton.height
			 MouseArea {
				anchors.fill: parent
                hoverEnabled: true
				onClicked: gameLauncher.launch
			 }
         }
         ToolButton {
             id: gridButton
             width: 125; height: 20
             iconSource: "../images/grid.png"
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
         ToolButton {
             id: fullscreenButton
             width: 125; height: 20
             iconSource: "../images/screen_expand_3.png"
             MouseArea {
                 anchors.fill: parent
                 hoverEnabled: true
                 onClicked: gameLauncher.fullscreen
             }
         }

        Slider { //Controls gameGrid icon size
            id: slider
            value: 75
            minimumValue: 1; maximumValue: 150
            width: bottomToolbar.width / 6
            anchors.right: parent.right
            anchors.rightMargin: 20
            style: SliderStyle {
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
}
