import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.1
import QtQuick.XmlListModel 2.0
import QtQuick.Dialogs 1.0

import game.launcher 1.0
import game.scan 1.0
import "js/appendModel.js" as AppendModel

//ON RIGHT CLICK IN GRIDVIEW BRING UP GAME DATA

Rectangle {
    id: root
    width: 1024
    height: 768

    Launcher {id: gameLauncher; path: gameTable.model.get(gameTable.currentRow).path; core: gameTable.model.get(gameTable.currentRow).core
            //gameView.model.get(gameView.currentIndex).path; //Make it so a status changes so this can decide
    }
    ScanDirectory {id: scanDirectory;}
    SystemPalette {id: systemColor; colorGroup: SystemPalette.Active}
    ///////////////////////////////////////////////////////////////////
    ////////                   Top Menu Bar                  //////////
    ///////////////////////////////////////////////////////////////////
    /*menuBar: MenuBar { //Doesn't do much as of yet/
        Menu {
            title: qsTr("Video")
            MenuItem {text: qsTr("Shader Options")}
            MenuItem {text: qsTr("Integer Scale")}
            MenuItem {text: qsTr("Aspect Ratio")}
            MenuItem {text: qsTr("Custom Ratio")}
            MenuItem {text: qsTr("Toggle Fullscreen")}
            MenuItem {text: qsTr("Rotation")}
            MenuItem {text: qsTr("VSync")}
            MenuItem {text: qsTr("Driver")}
            MenuItem {text: qsTr("Crop Overscan")}
        }
        Menu {
            title: qsTr("Audio")
            MenuItem {text: qsTr("Mute Audio")}
        }
        Menu {
            title: "Input"
        }
        Menu {
            title: qsTr("System")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }*/


    Menu {
        enabled: true
        title: "Edit"

        MenuItem {
            text: "Cut"
            shortcut: "Ctrl+X"
            //onTriggered: ...
        }

        MenuItem {
            text: "Copy"
            shortcut: "Ctrl+C"
            //onTriggered: ...
        }

        MenuItem {
            text: "Paste"
            shortcut: "Ctrl+V"
            //onTriggered: ...
        }

        MenuSeparator { }

        Menu {
            title: "More Stuff"

            MenuItem {
                text: "Do Nothing"
            }
        }
    }


    RowLayout {
        id: gameLayout
        anchors.top: parent.top
        anchors.bottom: bottomToolbar.top
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight: parent.height; implicitWidth: 500
        /////////////////////////////////////////////////////
        /////////          System List             //////////
        /////////////////////////////////////////////////////
        ColumnLayout {
            id: leftColumn
            z: gameTable.z + 1
            anchors.top: parent.top
            width: 250;
            anchors.bottom: parent.bottom
            state:  "ON"
            Rectangle {
                id: leftSide
                anchors.top: parent.top
                width: leftColumn.width; height: root.height / 2
                color: "#3a3935" //Controls background color
                Rectangle {
                    id: header
                    width: 250;
                    height: 25
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 10
                    //anchors.leftMargin: 10
                    anchors.right: parent.right
                    color: "#000000FF"
                    radius: 2
                    state: "ON"
                   //border.color: "#88F0B9"
                    //Image {anchors.fill: parent; source: "images/greenlabel.png"; sourceSize.width: header.}
                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        text: "<b>System</b>"
                        font.pixelSize: 12
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
                    width: parent.width; height: 300
                    anchors.top: header.bottom
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#000000FF"
                    Component {
                        id: highlightBar
                        Rectangle {
                            x: 40
                            width: background.width - 40; height: 25
                            y: filterMenu.currentItem.y;
                            color: "#29A7D7" //Highlighter Color
                            radius: 5
                            anchors.margins: 10
                        }
                    }
                ListView {
                    id: filterMenu
                    anchors.fill: parent
                    //anchors.leftMargin: 40
                    focus: true
                    highlightFollowsCurrentItem: false
                    highlight: highlightBar
                    interactive: false
                    model: SystemModel {}
                    delegate: Rectangle {
                        id: wrapper
                        width: filterMenu.width; height: 25
                        color: "#000000FF"
                        //x: 90
                        states: State {
                            name: "Current"
                            when: wrapper.ListView.isCurrentItem
                            PropertyChanges { target: wrapper; //x: -40
                            }
                            PropertyChanges { target: label; font.bold: true
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
                            onClicked: { filterMenu.currentIndex = index; filter()

                            }
                        }
                        Label {id: label;
                            anchors.verticalCenter: parent.verticalCenter;
                            text: name;
                            color: "white";
                            x: 50
                            height: paintedHeight + (textShadow1.radius * 2);
                            width: paintedWidth + (textShadow1.radius * 2);
                        }
                        /*DropShadow {
                            id: textShadow1
                            anchors.fill: source
                            source: label
                            radius: 4
                            samples: 8
                            verticalOffset: 1
                            horizontalOffset: 2
                            color: "#800000FF"
                        }*/
                    }
                }

            }
        }
            //////////////////////////////////////////////////////////
            ////////            Favorite's List               ////////
            //////////////////////////////////////////////////////////
            Rectangle {
                id: leftSide2
                width: leftColumn.width; height: 200
                anchors.top: leftSide.bottom
                //anchors.bottom: parent.bottom
                color: leftSide.color //Controls Background Color

                Rectangle {
                    id: favorites
                    width: 100;
                    height: 25
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 10
                    //anchors.leftMargin: 10
                    anchors.right: parent.right
                    color: "#000000FF" //Favorite's text background
                    radius: 2
                    Label {
                        id: favoritesLabel
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        text: "<b>Favorites</b>"
                        font.pixelSize: 12
                        renderType: Text.NativeRendering
                        color: "#FFFFF9"
                        height: paintedHeight + (textShadow2.radius * 2);
                        width: paintedWidth + (textShadow2.radius * 2);
                    }
                   /*DropShadow {
                        id: textShadow2
                        anchors.fill: source
                        source: favoritesLabel
                        radius: 4
                        samples: 8
                        verticalOffset: 1
                        horizontalOffset: 2
                        color: "#800000FF"
                    }*/
                }
                Rectangle {
                    id: background2
                    width: parent.width; height: 300
                    anchors.top: favorites.bottom
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#000000FF"
                    Component {
                        id: highlightBar2
                        Rectangle {
                            x: 40;
                            y: favoritesMenu.currentItem.y
                            width: leftColumn.width - 40; height: 25
                            //clip: true
                            //y: favoritesMenu.currentItem.y;
                            color: "#29A7D7" //Highlighter Color
                            radius: 5
                        }
                    }
            ListView {
                id: favoritesMenu
                anchors.fill: parent
                //anchors.leftMargin: 40
                focus: true
                highlightFollowsCurrentItem: false
                highlight: highlightBar2
                interactive: false
                model: FavoritesModel {}
                delegate: Rectangle {
                    id: wrapper2
                    width: favoritesMenu.width; height: 25
                    //x: 90
                    color: "#000000FF"
                    states: State {
                        name: "Current"
                        when: wrapper2.ListView.isCurrentItem
                        PropertyChanges { target: wrapper2; //x: -40
                        }
                        PropertyChanges { target: label2; font.bold: true
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: favoritesMenu.currentIndex = index
                    }
                    Text {
                        id: label2;
                        anchors.verticalCenter: parent.verticalCenter;
                        x: 50
                        text: name;
                        color: "white"
                        height: paintedHeight + (textShadow3.radius * 2);
                        width: paintedWidth + (textShadow3.radius * 2);
                    }
                   /* DropShadow {
                        id: textShadow3
                        anchors.fill: source
                        source: label2
                        radius: 4
                        samples: 8
                        verticalOffset: 1
                        horizontalOffset: 2
                        color: "#800000FF"
                    }*/
                }
            }
        }//Background Rectangle
    }//Favorite's Rectangle
            Rectangle {
                color: leftSide.color
                width: parent.width
                anchors.top: leftSide2.bottom
                anchors.bottom: parent.bottom
                Label {
                    id: quickLabel;
                    width: parent.width;
                    text: "Quick Settings"
                    font.bold: true
                    color: "white"
                    x: 15
                    font.pixelSize: 12
                }

                ColumnLayout {
                    anchors.topMargin: 15
                    anchors.top: quickLabel.bottom
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom

                    Rectangle {
                        id: inputButton
                        color: "#5828D7"
                        anchors.top: parent.top
                        anchors.right: parent.right
                        height: 20
                        width: 120
                        radius: 2
                        Label {anchors.centerIn: parent; text: "Input"; font.bold: true; color: "white"}
						MouseArea {
							anchors.fill: parent
                            onClicked: { gameLauncher.joy}

						}
                    }
                    Rectangle {
                        id: videoButton
                        color: "#28D7AF"
                        anchors.right: parent.right
                        height: 20
                        width: 120
                        radius: 2
                        Label {anchors.centerIn: parent; text: "Video"; font.bold: true; color: "white"}
                        MouseArea {
                            anchors.fill: parent
                            onClicked: AppendModel.addModel(gameModel, scanDirectory.iterate_data)
                        }
                    }
                    ShadersMenu {
                        id: shaderButton
                        color: "#D7AF28"
                        anchors.right: parent.right
                        height: 20
                        width: 120
                        radius: 2
                    }
					Rectangle {
						id: searchBar
						signal comboClicked;
						color: "#D7274E"
						smooth:true
						anchors.right: parent.right
						height: 20
						width: 120
						state: "CLOSED"
						states: State { name: "OPEN"; PropertyChanges { target: dropDown; width: 300 } }
						transitions: Transition {
							NumberAnimation { target: dropDown; properties: "width"; easing.type: Easing.OutExpo; duration: 1000 }
						}
						Label {
							//rotation: 180 /* second rotation */
							anchors.centerIn: parent
							id:chosenItemText
							color: "white"
							text:"Search";
							smooth:true
							font.bold: true
						}
						MouseArea {
							id: mousearea
							width: 400
							height: 30
							anchors.bottomMargin: 0
							anchors.fill: parent;
							onClicked: { if (searchBar.state === "CLOSED") {searchBar.state = "OPEN"}
								else {searchBar.state = "CLOSED"}
							}
							//onQt.Key_Return
						}
						Rectangle {
							id: dropDown
							width: 0
							height: parent.height * 1.7;
            				clip: true;
							anchors.left: searchBar.right;
							anchors.verticalCenter: searchBar.verticalCenter
							//anchors.margins:  5;
							color: parent.color
							TextField {
								id: textField
								anchors.top: parent.top;
								anchors.left: parent.left;
								anchors.right: parent.right
								anchors.bottom: parent.bottom
								anchors.margins: 5;
								Keys.onReturnPressed: searchBar.state = "CLOSED"
								Timer{ 
									id: filterTimer 
									interval:500 
									running: false 
									repeat: false 
									onTriggered: { 
										console.log("triggered"); 
										libraryModel.query = "/Library/game[contains(lower-case(child::title),lower-case(\""+textField.text+"\"))]"; 
										libraryModel.reload(); 
									}
								}//Timer
								onTextChanged:{  
									console.log(textField.text);  
									if (filterTimer.running) { console.log("restarted"); filterTimer.restart() }
									else { console.log("started"); filterTimer.start() } 
								}
							}//TextField
						}//Rectangle: dropDown	
					}
				}//Column Layout
			}//Rectangle: leftSide
		}
        //////////////////////////////////////////////////////////////////
        /////////               Game Table View                  /////////
        //////////////////////////////////////////////////////////////////
        TableView {
            id: gameTable
            model: LibraryModel {id: libraryModel}
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: leftColumn.right
            anchors.right: parent.right
            highlightOnFocus: true
            backgroundVisible: true
            onClicked: { console.log(gameTable.model.get(gameTable.currentRow).path) }
            headerDelegate: Rectangle {
                height: 25;
                color: leftSide.color
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: styleData.value
                    color: "white"
                    font.bold: true
					elide: styleData.elideMode
                    x: 13
                }
            }
            rowDelegate: Rectangle { height: 25; color: styleData.selected ?  "#29A7D7" : "#E4E7E9" }
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
               scrollBarBackground: Rectangle {
                    //height: 12
                    //color: "#BDC9F3"
                }
                handle: Rectangle {
                    height: 12; width: 30
                    color: "black"
                }
                decrementControl :Rectangle {
                    width: 20; height: 0
                    color: "black"
                }
            }

            TableViewColumn{role: "title"; title: "Name"; width: 300}
            /*TableViewColumn{
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
            TableViewColumn{role: "system"; title: "System"; width: 200}
            TableViewColumn{role: "core"; title: "Core"; width: 200}
        }
        //////////////////////////////////////////////////////////////////
        /////////               Game Cover Art Grid              /////////
        //////////////////////////////////////////////////////////////////
        Rectangle {
            id: gameGrid
            width: 800; height: 600
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: leftColumn.right
            anchors.right: parent.right
            color: "#D6DADE" //Grid Background Color
            visible: true
            z: -1
            GridView {
                property alias gameView: gameView
                id: gameView
                anchors.fill: parent
                anchors.margins: 20
                //columns: 5
                cellHeight: 250 + slider.value * 2
                cellWidth: 190 + slider.value * 2
                focus: true
                highlight: gameHighlighter
                model: libraryModel
                delegate: gameDelegate

            Component {
                id: gameHighlighter
                Rectangle {
                    opacity: 0.5
                    //color: "darkgray" //Highlighter Color
                    height: 20; width: 20
                    y: gameView.currentItem.y;
                }
            }
                Component {
                    id: gameDelegate
                    Rectangle {
                        width: 125 + slider.value * 2; height: 175 + gameLabel.contentHeight + slider.value * 2
                        color: "#000000FF"
                        id: gameFrame
                        states: State {
                            name: "Current"
                            when: gameList.ListView.isCurrentItem
                            }
                        MouseArea {
                            anchors.fill: parent
                            //hoverEnabled: true
                            onClicked: { gameView.currentIndex = index; console.log(gameView.model.get(gameView.currentIndex).path)}//console.log(gameList.model.get(gameList.currentItem).path) //Path is stored in DataModel
                            //onPressAndHold: gameView.destroy(gameView.currentIndex)
                        }
                        Rectangle {
                            id: gameRectangle
                            color: "#000000FF"
                            width: parent.width * 0.7; height: parent.height * 0.7
                            anchors.centerIn: parent
                            Image {
                                id: gameImage
                                source: "images/tv_color_bars.jpg"
                                anchors.centerIn: parent; //source: portrait
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                width: parent.width  ; height: parent.height
                                sourceSize.width: 500 ; sourceSize.height: 500
                            }
                        }
                        DropShadow{
                            cached: true
                            fast: true //May have to enable on slower systems
                            transparentBorder: true
                            anchors.fill: source
                            source: gameRectangle
                            radius: 8
                            samples: 16
                            color: "black"
                            verticalOffset: 3
                            horizontalOffset: 3
                        }
                        Label {
                            id: gameLabel
                            width: 170
                            anchors.topMargin: 10
                            anchors.top: gameRectangle.bottom;
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: title
                            font.pixelSize: 12
                            font.bold: true
                            wrapMode: Text.Wrap
                            elide: Text.ElideRight
                        }
                    }
                }
            }//ListView
        }//GridView





        /*GameGrid {
            id: gameGrid
            width: 100
            height: 250
            color: "#D6DADE" //Grid Background Color
            visible: false
            z: -1
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: leftColumn.right
            anchors.right: parent.right
            gameGrid.GridView.cellWidth: 200
        }*/


    }
    //////////////////////////////////////////////////////////////////
    /////////               Bottom Toolbar                  //////////
    //////////////////////////////////////////////////////////////////
    Rectangle {
     id: bottomToolbar
     anchors.bottom: parent.bottom
     anchors.left: parent.left
     anchors.right: parent.right
     height: 30
     width: parent.width
     color: leftSide.color //Toolbar Background Color

     RowLayout {
         anchors.fill: parent
         ToolButton {
             id: plusButton
             anchors.left: parent.left
             anchors.leftMargin: 15
             iconSource: "images/plus.png"
             implicitHeight: bottomToolbar.height * 0.7; implicitWidth:  plusButton.height
             MouseArea {
                 anchors.fill: parent
                 onClicked: {fileDialog.open(); //systemDirectory.directory = fileDialog.fileUrl
                 }
             }
             Timer { //Python creates xml it too quickly
                 id: dialogTimer
                 interval: 1000
                 repeat: false
                 running: false
                 onTriggered: libraryModel.reload()
             }
             FileDialog {
                 id: fileDialog
                 title: "Find Folder Containing Games"
                 selectFolder: true
                 onAccepted: {
                     console.log(fileDialog.fileUrl)
                     scanDirectory.directory = fileDialog.fileUrl
                     scanDirectory.scan
                     dialogTimer.start()

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
             iconSource: "images/play.png"
             implicitHeight: bottomToolbar.height * 0.7; implicitWidth:  plusButton.height
             //anchors.left: plusButton.right
             //anchors.leftMargin: 2
			 MouseArea {
				anchors.fill: parent
				onClicked: gameLauncher.launch
			 }
         }
         ToolButton {
             id: gridButton
             implicitHeight: bottomToolbar.height * 0.7; implicitWidth:  plusButton.height
             //anchors.right:search_bar.left
             //anchors.left: play_btn.right
             //anchors.rightMargin: 2
             iconSource: "images/grid.png"
             state: "ON"
             function toggle() { //makes the gridview switch
                 if (state === "ON"){state = "OFF"; gameGrid.visible = true;
                     gameTable.visible = false
                 }
                 else {state = "ON"; gameGrid.visible = false;
                     gameTable.visible = true
                 }
             }
             onClicked: toggle()
         }
         Slider { //Controls gameGrid icon size
             id: slider
             value: 75
             minimumValue: 1; maximumValue: 150
             //Layout.fillWidth: true
             width: bottomToolbar.width / 6
             anchors.right: parent.right
             anchors.rightMargin: 20
             //anchors.leftMargin: 20
             style: SliderStyle {
                 groove: Rectangle {
                     radius: 8
                     implicitHeight: 5
                     color: "#B05C5A"
                 }
                 handle: Rectangle {
                     radius: 8
                     implicitWidth: 15 ;implicitHeight: 15
                     color: "#29A7D7"
                 }
             }
        }
    }
}
}


