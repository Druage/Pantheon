import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

Rectangle {
    id: root;
    property string artworkSource;
    property var originalLibrary: libraryModel;
    color: "#2f2f2f";

    Rectangle {
        id: borderRectangle;
        color: "#2f2f2f";
        anchors.right: parent.right
        height: parent.height
        width: 1
    }


    function switchSystems(system) {
        var result;
        switch(system) {
            case "Nintendo Entertainment System":
                result = nesModel;
                break;
            case "Super Nintendo":
                result = snesModel;
                break;
            case "Nintendo 64":
                result = n64Model;
                break;
            case "Sony PlayStation":
                result = psxModel;
                break;
            case "Virtual Boy":
                result = vbModel;
                break;
            case "Indie":
                result = indieModel;
                break;
            case "Game Boy":
            case "Game Boy Color":
                result = gbModel;
                break;
            case "Game Boy Advance":
                result = gbaModel;
                break;
            case "Sega Genesis":
                result = genesisModel;
                break;
            case "Arcade":
                result = arcadeModel;
                break;
            case "Film":
                result = filmModel;
                break;
            default:
                result = undefined;
                break;
        }
        return result;
    }

    function selectCore(model) {
        var result;
        switch (model) {
            case "Nintendo Entertainment System":
                result = "core_nes";
                break;
            case "Super Nintendo":
                result = "core_snes";
                break;
            case "Nintendo 64":
                result = "core_n64";
                break;
            case "Sony PlayStation":
                result = "core_psx";
                break;
            case "Virtual Boy":
                result = "core_vb";
                break;
            case "Game Boy Color":
            case "Game Boy":
                result = "core_gb";
                break;
            case "Game Boy Advance":
                result = "core_gba";
                break;
            case "Indie":
                result = "core_indie";
                break;
            case "Sega Genesis":
                result = "core_gen";
                break;
            case "Arcade":
                result = "core_arcade";
                break;
            case "Film":
                result = "core_film";
                break;
        }
        return result;
    }

    ColumnLayout {
        anchors.fill: parent;

        ListModel {
            id: systemListModel;
            ListElement {console: "All";}
            ListElement {
                console: "Nintendo Entertainment System";
                //icon: "../../images/console_icons/nes.png"

            }
            ListElement {
                console: "Super Nintendo";
                //icon: "../../images/console_icons/super-nintendo.png"
            }
            ListElement {
                console: "Nintendo 64";
                //icon: "../../images/console_icons/nintendo-64.png"
            }
            ListElement {
                console: "Sony PlayStation";
                //icon: "../../images/console_icons/sony-playstation.png"
            }
            ListElement {
                console: "Virtual Boy";
                //icon: "../../images/console_icons/virtual_boy.png"
            }
            ListElement {
                console: "Game Boy";
                //icon: "../../images/console_icons/gameboy.png"
            }
            ListElement {
                console: "Game Boy Color";
                //icon: "../../images/console_icons/gameboy_color.png"
            }
            ListElement {
                console: "Game Boy Advance";
                //icon: "../../images/console_icons/gameboy_advance.png"
            }
            ListElement {
                console: "Sega Genesis";
                //icon: "../../images/console_icons/sega-genesis.png"
            }
            ListElement {
                console: "Arcade";
                //icon: "../../images/console_icons/arcade.png"
            }
            ListElement {
                console: "Film";
            }
            ListElement {
                console: "Indie";
            }
        }
        Label {
            anchors.top: parent.top;
            anchors.left: parent.left;
            anchors.margins: 10;
            id: systemLabel;
            text: "System";
            color: "#bfbcbc";
            font.bold: true;

        }

        ListView {
            id: listView;
            anchors.top: systemLabel.bottom;
            anchors.topMargin: 10;
            width: parent.width;
            height: root.height / 2;
            interactive: false;
            model: systemListModel;
            highlightFollowsCurrentItem: false;
            keyNavigationWraps: true;
            spacing: 2;

            highlight:
                Component {
                    Rectangle {
                        //anchors.verticalCenter: parent.verticalCenter
                        width: 245;
                        height: 2;
                        x: 25;
                        anchors {
                            bottom: listView.currentItem.bottom;
                        }
                        color: "white";
                        y: listView.currentItem.y
                       /*Behavior on y {
                            SpringAnimation {
                                spring: 3
                                damping: 0.2
                            }
                        }*/

                    }
                }

            delegate:
                Item {
                    id: listDelegate
                    anchors.left: parent.left
                    anchors.leftMargin: 25
                    width: parent.width;
                    height: 23;
                        states:
                            State {
                                name: "Current";
                                when: listDelegate.ListView.isCurrentItem;
                                PropertyChanges { target: listDelegate; x: 20 }
                            }
                    MouseArea {

                        Menu {
                            id: consoleRightClickMenu;
                            property bool opened: false;
                            property string systemConsole: listDelegate.ListView.view.model.get(
                                                            listDelegate.ListView.view.currentIndex
                                                            ).console;
                            ExclusiveGroup {
                                id: coreGroup;
                            }
                            Instantiator {
                                id: consoleInstan;
                                model: switchSystems(
                                           listDelegate.ListView.view.model.get(
                                               listDelegate.ListView.view.currentIndex).console);
                                MenuItem {
                                    id: menuItem;
                                    property bool popped: consoleRightClickMenu.opened;
                                    checkable: true;
                                    exclusiveGroup: coreGroup;
                                    text: model.title ? model.title : "";
                                    onTriggered: {
                                        consoleRightClickMenu.systemConsole = listDelegate.ListView.view.model.get(listDelegate.ListView.view.currentIndex).console;
                                        cfg[selectCore(consoleRightClickMenu.systemConsole)] = model.core;
                                        menuItem.checked = (text === cfg[selectCore(consoleRightClickMenu.systemConsole)]);

                                    }
                                    onPoppedChanged: {
                                        if (popped) {
                                            checked = (model.core === cfg[
                                                           selectCore(
                                                               consoleRightClickMenu.systemConsole
                                                               )]);
                                        }
                                    }
                                }
                                onObjectAdded: consoleRightClickMenu.insertItem(index, object);
                                onObjectRemoved: consoleRightClickMenu.removeItem(object);
                            }


                            onPopupVisibleChanged: {
                                if (opened) {
                                    opened = false;
                                }

                            }

                            MenuSeparator {
                                visible: consoleRightClickMenu.count > 0;
                            }

                           /* MenuItem {
                                text: "Clear menu"
                                enabled: consoleRightClickMenu.count > 0
                                onTriggered: consoleRightClickMenu.clear()
                            }*/
                        }

                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        hoverEnabled: true

                        function filter(text) {
                            _libraryModel.query = "$[?(@.console.indexOf('"
                                                  + model.console +"') !== -1)]";
                        }

                        onClicked: {
                            listDelegate.ListView.view.currentIndex = index;
                            if (mouse.button == Qt.LeftButton) {
                                if (model.console !== "All")
                                    filter();
                                else {
                                    _libraryModel.reload();
                                    _libraryModel.query = "$[*]";
                                }
                            }
                            else if (mouse.button == Qt.RightButton) {
                                if (consoleInstan.model !== undefined) {
                                    consoleRightClickMenu.opened = true;
                                    consoleRightClickMenu.popup();
                                }
                            }
                        }
                    }
                    Row {
                        anchors.verticalCenter: parent.verticalCenter;
                        spacing: 5;
                        Image {
                            sourceSize.height: 18;
                            sourceSize.width: 20;
                            source: model.icon ? model.icon : "";
                        }

                        Label {
                            id: labelDelegate
                            anchors.verticalCenter: parent.verticalCenter
                            text: model.console
                            color: "#bfbcbc";
                        }
                    }
                }
        }

            Image {
                id: tableArtwork
                height: 200
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                cache: true
                fillMode: Image.PreserveAspectFit
                sourceSize.width: 250
                sourceSize.height: 250
                source: artworkSource
            }

            InnerShadow{
                id: gameShadow
                anchors.fill: source
                source: tableArtwork
                //transparentBorder: true
                enabled: true
                radius: 8
                samples: 16
                color: "#80000000"
                verticalOffset: 3
                horizontalOffset: 3
            }
    }
}
