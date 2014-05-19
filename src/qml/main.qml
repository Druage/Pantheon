import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.1
import QtQuick.XmlListModel 2.0
import QtQuick.Dialogs 1.0

// C++
import Library 1.0
import Launch 1.0
import Shader 1.0
import Config 1.0

// Themes
import "Themes/OpenEmu (Red)/TableView"
import "Themes/OpenEmu (Red)/SliderStyled"
import "Themes/OpenEmu (Red)/SearchBarStyle"
import "Themes/OpenEmu (Red)/CheckBoxStyled"

// Local Folders
import "RomTable"
import "RomGrid"
import "TopMenuBar"
import "BottomStatusBar"
import "Settings"
import "GameCounter"
import "LeftConsoleList"
import "JSONListModel"

// Javascript
import "../js/toggleChecked.js" as ToggleChecked
import "../js/model.js" as MyModel
import "../js/load_dialog.js" as LoadDialog
import "../js/check.js" as Check

ApplicationWindow {
    id: root;

    property var libraryModel: _libraryModel.model;

    width: 1024;
    height: 768;
    title: "Pantheon";

    Library {
        id: library;
    }

    Shader {
        id: shader;
    }

    Launch {
        id: launcher;
    }

    function appendConsoles(model, core_array, system) {
        for (var core in core_array)
            model.append({system: core_array[core]})
    }

    ListModel {
        id: nesModel;
        ListElement {title: "bNES"; core: "bnes_libretro.dll";}
        ListElement {title: "Nestopia"; core: "nestopia_libretro.dll";}
        ListElement {title: "QuickNES"; core: "quicknes_libretro.dll";}
    }

    ListModel {
        id: snesModel;
        ListElement {title: "bsnes (Accurarcy)"; core: "bsnes_accuracy_libretro.dll";}
        ListElement {title: "bsnes (Balanced)"; core: "bsnes_balanced_libretro.dll";}
        ListElement {title: "bsnes (Performance)"; core: "bsnes_performance_libretro.dll";}
        ListElement {title: "Snes9x"; core: "snes9x_libretro.dll";}
        ListElement {title: "Snes9x Next"; core: "snes9x_next_libretro.dll";}
    }
    ListModel {
        id: n64Model;
        ListElement {title: "Mupen64Plus"; core: "mupen64plus_libretro.dll";}
    }
    ListModel {
        id: psxModel;
        ListElement {title: "Mednafen PlayStation"; core: "mednafen_psx_libretro.dll";}
    }
    ListModel {
        id: genesisModel;
        ListElement {title: "Genesis Plus GX"; core: "genesis_plus_gx_libretro.dll";}
    }
    ListModel {
        id: gbModel;
        ListElement {title: "Gambatte"; core: "gambatte_libretro.dll";}
    }
    ListModel {
        id: gbaModel;
        ListElement {title: "Meteor"; core: "meteor_libretro.dll";}
        ListElement {title: "Visual Boy Advance Next"; core: "vba_next_libretro.dll";}
        ListElement {title: "Visual Boy Advance - M"; core: "vbam_libretro.dll";}
    }
    ListModel {
        id: vbModel;
        ListElement {title: "Mednafen Virtual Boy"; core: "mednafen_vb_libretro.dll";}
    }
    ListModel {
        id: arcadeModel;
        ListElement {title: "MAME"; core: "mame078_libretro.dll";}
        ListElement {title: "Final Burn Alpha"; core: "fb_alpha_libretro.dll";}
    }
    ListModel {
        id: filmModel;
        ListElement {title: "FFmpeg"; core: "ffmpeg_libretro.dll";}
    }
    ListModel {
        id: indieModel;
        ListElement {title: "Dinothawr"; core: "dinothawr_libretro.dll";}
    }
    ListModel {
        id: pcModel;
        ListElement {title: "DOSbox"; core: "dosbox_libretro.dll";}
    }

    SystemPalette {id: systemPalette;}

    Loader {id: loader;}

    JSONListModel {
        id: _libraryModel;
        source: "library.json";
        query: "$[*]";
    }

    AdvancedSettings {
        id: advancedDialog;
        visible: false;
        //_defaultTableStyle: gameTable.style
        //openEmuRedTable: openEmuRed

        onClosing: {
            root.cfg = advancedDialog._cfg;
            root.frontend_cfg = advancedDialog._frontend_cfg;
        }
    }

    Component {
        id: openEmuRed;
        TableStyle {}
    }

    Component {
        id: openEmuRedSlider;
        SliderStyled {}
    }

    Component {
        id: openEmuRedSearchBar;
        SearchBarStyle {}
    }

    Component {
        id: openEmuCheckBox;
        CheckBoxStyled {}
    }

    //menuBar:
        //TopMenuBar {id: menuBar;}

    toolBar:
        BottomStatusBar {
            id: bottomToolbar;
        }
        /*ProgressBar {
            id: progressBar;
            height: 10;
            width: parent.width;
            maximumValue: 100;
            minimumValue: 0;
            visible: false;
            indeterminate: true;
        }*/

    //statusBar:

    /// Creates Rectangle over ApplicationWindow
    Rectangle {
        id: gameLayout;
        anchors.top: parent.top;
        anchors.bottom: settings.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        color: "#000000FF";

        GameCounter {
            id: gameCount
            anchors.bottom: parent.bottom;
            anchors.right: parent.right;
            anchors.bottomMargin: 30;
            anchors.rightMargin: 30;
            height: 20;
        }

        /// Status Update at Top Right Edge
        StatusUpdate {
            id: statusUpdate;
        }

        StackView {
            id: leftColumnStackView;
            property string artworkSource;
            property var gradientStyle;
            property string fontColor;
            property string backgroundColor: "#000000FF";
            property string borderColor: "lightgray";
            property var _frontend_cfg: root.frontend_cfg;
            enabled: false;
            anchors.top: parent.top;
            width: 300;
            anchors.bottom: parent.bottom;
            initialItem: leftColumn;
            delegate: StackViewDelegate {
                function transitionFinished(properties)
                {
                    properties.exitItem.x = 0;
                    properties.exitItem.rotation = 0;
                }

                property Component pushTransition: StackViewTransition {
                    SequentialAnimation {
                        ScriptAction {
                            script: enterItem.rotation = 90
                        }
                        PropertyAnimation {
                            target: enterItem
                            property: "x"
                            from: enterItem.width
                            to: 0
                        }
                        PropertyAnimation {
                            target: enterItem
                            property: "rotation"
                            from: 90
                            to: 0
                        }
                    }
                    PropertyAnimation {
                        target: exitItem
                        property: "x"
                        from: 0
                        to: -exitItem.width
                    }
                }
            }
        }

        Component {
            id: leftColumn;
            LeftConsoleList {
                artworkSource: leftColumnStackView.artworkSource;
            }
        }


    StackView {
        id: stackView
        property string gridTextColor;
        property string gridBackgroundColor: "white";
        property string noiseGradient: "";
        anchors.top: parent.top;
        height: parent.height + 1;
        anchors.left: leftColumnStackView.right;
        anchors.right: parent.right;
        initialItem: gameTable;
        delegate:
            StackViewDelegate {
                function transitionFinished(properties) {
                    properties.exitItem.x = 0
                    properties.exitItem.rotation = 0
                }
                property Component pushTransition: StackViewTransition {
                    SequentialAnimation {
                        ScriptAction {
                            script: enterItem.rotation = 90
                        }
                        PropertyAnimation {
                            target: enterItem
                            property: "x"
                            from: enterItem.width
                            to: 0
                        }
                        PropertyAnimation {
                            target: enterItem
                            property: "rotation"
                            from: 90
                            to: 0
                        }
                    }
                    PropertyAnimation {
                        target: exitItem
                        property: "x"
                        from: 0
                        to: -exitItem.width
                    }
                }
        }
    }

    RomTable {
        id: gameTable;
        theme: systemPalette;
        _model: libraryModel;
        _cfg: root.cfg;
        _frontend_cfg: root.frontend_cfg;
        onRowImageSourceChanged: {
            leftColumnStackView.artworkSource = rowImageSource;
        }
    }

    Component {
        id: componentGrid;

        Rectangle {
            id: gameGrid;
            width: 800;
            height: 600;
            color: "#222222"; //Grid Background Color

            Image {
                anchors.fill: parent;
                source: stackView.noiseGradient;
            }
            RomGrid {
                id: gameView;
            }

            Component {
                id: gameDelegate;
                    Item {
                        id: gameFrame;
                        width: gameView.cellWidth;
                        height: gameView.cellHeight;
                        states:
                            State {
                                name: "Current";
                                when: gameList.ListView.isCurrentItem;
                            }
                        Item {
                            id: gameRectangle;
                            anchors.fill: parent;
                            anchors.centerIn: parent;
                            anchors.margins: 40;
                            Image {
                                id: gameImage;
                                z: gameRectangle.z + 1;
                                cache: true;
                                source: image;
                                fillMode: Image.PreserveAspectFit;
                                anchors {
                                    fill: parent;
                                    margins: 20;
                                }
                                asynchronous: true;
                                sourceSize.width: 500;
                                sourceSize.height: 500;
                            }
                        }
                }
            }

        }
    }
    }
    Rectangle {
        anchors.bottom: parent.bottom;
        id: settings;
        width: parent.width;
        height: 0;
        rotation: 180;
        states: [
            State {
                name: "clicked";
                PropertyChanges {target: settings; height: 100;}
                PropertyChanges {target: topMenu; enabled: true;}
                PropertyChanges {target: settingsButton; visible: true;}
            }
        ]
        transitions:
            Transition {
                PropertyAnimation {property: "height"; easing.type: Easing.OutQuad;}
            }
        RowLayout {
            id: topMenu;
            anchors.fill: parent;
            enabled: false;
            rotation: 180;
        }
    }

}
