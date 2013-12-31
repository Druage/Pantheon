//Done using Qt Creator 5.2
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
import QtGraphicalEffects 1.0


ApplicationWindow {
    id: root
    title: qsTr("RetroArch Phoenix")
    width: 640
    height: 480

    /*menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
        Menu {
            title: qsTr("Video")
            MenuItem {
                text: qsTr("Shader")
            }
        }
    }*/
    ColumnLayout {
        id: col
        //Rectangle {anchors.fill: parent; color: "blue"}
        anchors.fill: parent
        SplitView {
            id: body
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: footer.top
            anchors.left:  parent.left
            orientation: Qt.Horizontal
            LeftPane {
                id: system_list
                width: col.width / 4
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                //right anchor is defined in TableView
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
            RomGrid {
                property alias romGrid: rom_grid
                id: rom_grid
                visible: false
                anchors.right: parent.right
                anchors.left: system_list.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
            }
        }

        //BottomBar
        FooterBar {
            id: footer
            height: 75
            width: 150 //not being actually used
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.bottom
        }
    }
}
