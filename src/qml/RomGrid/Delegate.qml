import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.1
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.1
import "../../js/check.js" as Check


Item {
    id: root;
    height: 200// + bottomToolbar.sliderVal;
    width: 300// + bottomToolbar.sliderVal;
    function compareSystem(system) {
        var result = "";
        var index;
        switch(system) {
            case "Nintendo Entertainment System":
                result = cfg["core_nes"];
                break;
            case "Super Nintendo":
                result = cfg["core_snes"];
                break;
            case "Nintendo 64":
                result = cfg["core_n64"];
                break
            case "Game Boy":
            case "Game Boy Color":
                result = cfg["core_gb"];
                break
            case "Game Boy Advance":
                result = cfg["core_gba"];
                break;
            case "Sony PlayStation":
                result = cfg["core_psx"];
                break
            case "Arcade":
                result = cfg["core_arcade"];
                break
            case "Virtual Boy":
                result = cfg["core_vb"];
                break
            case "Computer":
                result = cfg["core_pc"];
                break
            case "Sega Genesis":
                result = cfg["core_gen"];
                break
            case "Film":
                result = cfg["core_film"];
                break
            case "Indie":
                result = cfg["core_indie"];
                break
            default:
                result = "System was not assigned"
                break;
        }
        return result;
    }

    GridRightClickMenu {id: rightClickMenu;}

    ColumnLayout {
        id: column;
        //anchors.fill: parent;
        anchors.centerIn: parent;
        height: parent.height + bottomToolbar.sliderVal;
        width: parent.width + bottomToolbar.sliderVal;
        Flipable {
            id: flipable
            z: parent.z;
            property bool flipped: false;
            property bool sliderChanging: bottomToolbar.sliderPressed;
            anchors {
                centerIn: parent;
                fill: parent;
                margins: 20;
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                onClicked:  {
                    gameView.currentIndex = index;
                    console.log(gameView.width + " :::  " + root.width)
                    console.log(gameView.width / (root.width))
                    console.log(gameView.currentIndex)

                    if (mouse.button === Qt.MiddleButton) {
                        flipable.flipped = !flipable.flipped;
                    }
                    else if (mouse.button === Qt.RightButton) {
                        rightClickMenu.popup()
                    }
                }
                onDoubleClicked: {
                    var rom_path = gameView.model.get(gameView.currentIndex).path;
                    var core_path = cfg["libretro_path"] + '/' +
                            compareSystem(gameView.model.get(gameView.currentIndex).console);

                    if (cfg["exe_path"] === "" ||
                            cfg["cfg_file"] === "" ||
                            core_path === '\n' ) {

                        statusUpdate.visible = true
                        statusUpdate.text = "You must provided paths for the RetroArch executable, cores, and config"
                        statusTimer.start()
                    }
                    else {

                        if (cfg["cfg_file"] !== "") {
                            py.call("storage.json_to_cfg", [cfg["cfg_file"], cfg], function (result) {
                                if (result) {
                                    py.call_sync('retroarch_launch.launch',
                                                 [cfg["retroarch_exe_path"],
                                                  rom_path,
                                                  core_path,
                                                  cfg["cfg_file"]]
                                                )
                                }
                            })
                        }
                    }
                }
            }

             FileDialog {
                 id: artworkDialog
                 title: "Find Artwork"
                 nameFilters: ["Image files (*.jpg *.png *.svg)", "All files (*)" ]
                 onAccepted: {
                     var artUrl = artworkDialog.fileUrl.toString()
                     gameView.model.get(gameView.currentIndex).image = artUrl
                     oldModel.get(gameView.currentIndex).image = artUrl
                 }
             }



            transform:
                Rotation {
                    id: rotation
                    origin.x: flipable.width/2
                    origin.y: flipable.height/2
                    axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
                    angle: 0    // the default angle
                }
            states:
                State {
                    name: "back"
                    PropertyChanges {target: rotation; angle: 180}
                    when: flipable.flipped;
                }
                transitions:
                    Transition {
                        NumberAnimation {
                            target: rotation;
                            property: "angle";
                            duration: 500;
                        }
                    }
            front:
                Image {
                    z: flipable.z;
                    id: frontImage;
                    source: image
                    fillMode: Image.PreserveAspectFit;
                    anchors.fill: parent;

                }

            DropShadow {
                id: rectShadow;
                source: frontImage;
                anchors.fill: source
                cached: true;
                visible: !flipable.flipped && !flipable.sliderChanging;
                horizontalOffset: 4;
                verticalOffset: 2;
                radius: 8.0;
                samples: 16;
                color: "black"//"#80000000";
                smooth: true;
                transparentBorder: true;
            }

            back:
                Image {
                    anchors.horizontalCenter: frontImage.horizontalCenter
                    height: frontImage.paintedHeight;
                    width: frontImage.paintedWidth;
                    source: "../../images/Phoenix64.png"
                    /*Column {
                        anchors.fill: parent;
                        spacing: 5;
                        TextArea{

                            width: parent.width;
                            text: description
                            readOnly: true;
                        }
                        Row {
                            spacing: 10;
                            Label {
                                text: publisher;
                                font.bold: true;
                            }
                            Label {
                                text: genre;
                                font.bold: true;
                            }
                        }
                    }*/
                }
        }
        Label {
            anchors {
                top: flipable.bottom;
                topMargin: 10;
                horizontalCenter: parent.horizontalCenter;
            }
            text: title
            font.bold: true
            color: stackView.gridTextColor
            elide: Text.ElideRight

        }
    }
    Rectangle {
        id: gameDropPane;
        z: flipable.z;
        visible: false;
        property bool dropped: false;
        anchors {
            top: column.bottom;
            topMargin: 20;
        }
        x: -40
        height: flipable.flipped ? 300: 0;
        width: gameView.width + 60;
        color: systemPalette.dark;

        onHeightChanged: {

        }

        RowLayout {
            id: row;
            anchors.fill: parent;

            Label {
                text: "Hello, world";

            }
        }
    }
}

