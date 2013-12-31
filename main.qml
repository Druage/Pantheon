//Done using Qt Creator 5.2
import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.0
import QtGraphicalEffects 1.0


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
        Row {
            id: body
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: footer.top
            anchors.left:  parent.left
            LeftPane {
                id: system_list
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: rom_list.left
                anchors.left: parent.left
                width: 225
            }
            //RomList
            ListModel {
               id: libraryModel
               ListElement{ name: "The Legend of Zelda" ; system: "NES" }
               ListElement{ name: "Pokemon Red"    ; system: "Game Boy" }
               ListElement{ name: "Super Mario Bros."   ; system: "NES" }
               ListElement{ name: "Final Fantasy VI"   ; system: "SNES" }
               ListElement{ name: "Majora's Mask"   ; system: "N64" }
               ListElement{ name: "Sonic"   ; system: "Genesis" }
               ListElement{ name: "Final Fantasy VII"   ; system: "PSX" }
            }

            TableView {
                property alias romList: rom_list
               id: rom_list
               anchors.right: parent.right
               anchors.left: system_list.right
               anchors.top: parent.top
               anchors.bottom: parent.bottom
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
               TableViewColumn{
                   role: "system"
                   title: "Sytem"
                   width: 100
               }
               TableViewColumn{
                   role: "name"
                   title: "Name"
                   width: 200
               }
               model: libraryModel
               style: TableViewStyle {
                   backgroundColor: "#0f0f0f"
                   alternateBackgroundColor: "#1d1d1d"
                   textColor: "white"

               }
            }
           Loader {
                property alias romGrid: rom_grid_loader
                id: rom_grid_loader
                anchors.left: system_list.right
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top: parent.top
            }
        }
        //BottomBar
        Loader {
            id: footer
            source: "FooterBar.qml"
            height: 175
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: system_list.bottom
        }
    }
}
