//Done using Qt Creator 5.2
import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.0
import QtGraphicalEffects 1.0
import QtQuick.XmlListModel 2.0


ApplicationWindow {
    id: root
    title: qsTr("RetroArch Phoenix")
    width: 640
    height: 480
    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
        Menu {
            title: qsTr("Video")
            MenuItem {text: qsTr("Shader")}
            MenuItem {text: qsTr("Enable Rewind")}
        }
        Menu {
            title: qsTr("Audio")
            MenuItem {text: qsTr("Mute Audio")}
        }
        Menu {
            title: qsTr("NetPlay")
        }
    }
    ColumnLayout {
        id: col
        anchors.fill: parent
        Item {
            id: body
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: footerbar.top
            anchors.left:  parent.left
           WindowLeftside {
                id: system_list
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: rom_list.left
                anchors.left: parent.left
                width: 225
            }
            //RomList

            XmlListModel {
               id: xmlModel
               source: "retroarch.xml"
               query: "/retroarch"
               XmlRole {name: "settings"; query: "libretro_path/string()"}
            }

            TableView {
               id: rom_list
               anchors.right: parent.right
               anchors.left: system_list.right
               anchors.top: parent.top
               anchors.bottom: parent.bottom
               model: xmlModel
               TableViewColumn{role: "settings"; title: "Sytem"; width: 100}
               TableViewColumn{role: "settings"; title: "Name"; width: 200}
               InnerShadow {
                   anchors.fill: parent
                   //visible: false
                   cached: true
                   verticalOffset: -3
                   horizontalOffset: 1
                   radius: 8.0
                   samples: 16
                   color: "black"
                   source: rom_list
               }
               style: TableViewStyle {
                   backgroundColor: "#0f0f0f"
                   alternateBackgroundColor: "#1d1d1d"
                   textColor: "white"
               }
            }
            //////////////////////////
            // Grid with Game Images//
            //////////////////////////
           RomView {
                property alias romGrid: rom_grid
                id: rom_grid
                visible: false
                anchors.left: system_list.right
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                //width: 100
                //height: 250
                //color: "gray"
                NoisyGradient {
                    width: parent.width; height: parent.height
                }

                /*gradient: Gradient {
                    GradientStop {position: 0.0; color: "#323232"}
                    GradientStop {position: 1.0; color: "#272727"}
                }*/
                    GridView {
                        id: game_grid
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.topMargin: 20
                        anchors.bottomMargin: 20
                        cellHeight: 150
                        cellWidth: 190
                        model: ModelGame {}
                        delegate: gameDelegate
                  ListView {
                      id: gameview
                      width: 100+ slider.value * 2; height: 150 + slider.value * 2 //Makes the slider adjust the game box height % width
                      model: ModelGame {}
                    Component {
                        id: gameDelegate
                        Column {
                            Rectangle {
                                width: gameview.height; height: gameview.width
                                color: "red"
                                id: rect
                                visible: true
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
                                    anchors.centerIn: parent; source: portrait
                                    //fillMode: Image.PreserveAspectCrop
                                    smooth: true
                                    width: parent.width  ; height: parent.height
                                    sourceSize.width: 500 ; sourceSize.height: 500
                                }
                            }
                            Item {
                                anchors.top: rect.bottom
                                anchors.topMargin: 5
                                //x: rect.width / 5
                                Text {text: name; color: "white"}

                                }
                            }
                        }
                    }
                }
            }
        }

        ///////////////////////////////////////////
        //Bottom Toolbar with Searchable Features//
        ///////////////////////////////////////////
        Rectangle {
            id: footerbar
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            //anchors.top: system_list.bottom
            implicitHeight: 75
            width: 150
            border.width: 2
            border.color: "#505050"
            InnerShadow {
                anchors.fill: parent
                //visible: false
                cached: true
                verticalOffset: -1
                horizontalOffset: 1
                radius: 10
                samples: 16
                color: "black"
                source: footerbar
            }
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#333333"}
                GradientStop { position: 1.0; color: "#262626"}
            }
            RowLayout {
                anchors.fill: parent
                PlusButton {
                    id: plus_btn
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                }
                PlayButton {
                    id: play_btn
                    anchors.left: plus_btn.right
                    anchors.leftMargin: 2
                }
                RomButton {
                    id: grid_btn //I'll turn these all into one button eventually
                    anchors.right:search_bar.left
                    //anchors.left: play_btn.right
                    anchors.rightMargin: 2
                }
                TextField {
                    id: search_bar
                    placeholderText: "Search..."
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    style: TextFieldStyle {
                        //placeholderTextColor: "white"
                        textColor: "white"
                        background: Rectangle {
                            radius: 10
                            //border.width: control.activeFocus ? 2 : 1
                            //border.color: "#1c9099"
                            implicitHeight:30
                            implicitWidth: root.width / 3
                            gradient: Gradient {
                                GradientStop {position: 0.0; color: "#353535"}
                                GradientStop {position: 1.0; color: "#232323"}
                            }
                            InnerShadow {
                                id: search_bar_shadow
                                anchors.fill: parent
                                visible: true
                                cached: true
                                verticalOffset: 3
                                horizontalOffset: -3
                                radius: 8.0
                                samples: 16
                                color: "black"
                                source: search_bar
                            }
                        }
                    }
                }
                Slider {
                    id: slider
                    minimumValue: 1; maximumValue: 100
                    style: SliderStyle {
                        groove: Rectangle {
                                id: groove
                                implicitWidth: root.width / 8
                                implicitHeight: 8
                                radius: 8
                                color: "#3690c0" // too small for useful gradient
                                InnerShadow {
                                    anchors.fill: groove
                                    //visible: false
                                    cached: true
                                    verticalOffset: 2
                                    horizontalOffset: -2
                                    radius: 10
                                    samples: 16
                                    color: "black"
                                    source: groove
                                }
                            }
                        handle: Rectangle{
                            id: handle
                            height: 17
                            width: 17
                            radius: 10
                        }
                    }
                }
            }
        }
    }
}
