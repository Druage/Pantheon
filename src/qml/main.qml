import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.1
import QtQuick.XmlListModel 2.0
import QtQuick.Dialogs 1.0
import io.thp.pyotherside 1.0

import "../js/model.js" as MyModel
import "../js/load_dialog.js" as LoadDialog

ApplicationWindow {
    id: root
    width: 1024
    height: 768
    SystemPalette {id: systemPalette}
    Loader {id: customCoreDialog}

    Python {
        id: py

        signal download(string result)
        signal unzip(string result)

        property string fullscreen: ""
        property string core_path: ""
        property string rom_path: ""

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../py'));
            setHandler('download', download)

            importModule('storage', [], function (){})
            importModule('retroarch_cfg', function () {})
            importModule('retroarch_launch', function () {})
            importModule('download', function () {})

            importModule('create_config', function () {
                py.call('create_config.write_config', [], function(result) {
                    console.log("Wrote initial config")
                })
            })
            importModule('check_cores', function () {
                py.call('check_cores.get_matches', [], function(result) {
                    for (var i=0; i<result.length; i++) {
                        coresModel.append(result[i]);
                    }
                });
                py.call('check_cores.cores_list', [1], function(result) {
                    for (var i=0; i<result.length; i++) {

                        avaiableCores.append(result[i]);
                    }
                })
                py.call('check_cores.get_title', [1], function(result) {
                    for (var i=0; i<result.length; i++) {
                        shaderModel.append(result[i]);
                    }
                })
            });
        }
        onReceived: console.log('Unhandled event: ' + data)
        onDownload: {console.log(result); sysMenu.text = result}
        onError: console.log('Error: ' + traceback)
    }

    menuBar:
        MenuBar {
            Menu {
                title: "System"
                MenuItem {
                    id: sysMenu
                    text: "Download RetroArch"
                    onTriggered: {
                        py.call("download.start_process", [],
                            function (result) {
                                console.log('Download: ' + result)}
                        )
                        sysMenu.text = "Download RetroArch"
                    }
                }
                MenuItem {
                    text: "Clear Library"
                    onTriggered: {
                        py.call('storage.clear', [], function (result) {
                            console.log(result)
                            libraryModel.reload()
                        })
                    }
                }
            }

            Menu {
                title: "Paths"
                FileDialog {
                    id: fileDialog
                    title: "Find Folder Containing Games"
                    selectFolder: true
                    onAccepted: {
                        LoadDialog.reloadComponent(callXmlLoader, callXmlCreator)
                        progressBar.visible = true
                    }
                    onRejected: {console.log("Cancelled"); fileDialog.close()}
                }

                MenuItem {
                    text: "Add Folder"
                    onTriggered: {
                        fileDialog.open()
                    }
                }
            }

            Menu {
                Loader {id: callJoyConfig}
                title: "Input"
                MenuItem {
                    text: "Configure Controller"
                    onTriggered: {
                        LoadDialog.reloadComponent(callJoyConfig, Qt.createComponent("CallTerminal.qml"))
                    }
                }
            }

           Menu {
               title: "Video"
               Menu {
                   id: shaderbar
                   title: "Shaders"
                   Instantiator {
                       id: instan
                       model: ListModel {id: shaderModel}
                       MenuItem {
                           id: shaders
                           text: shader_path
                           //property var directory: path
                           onTriggered: {
                                py.call('retroarch_cfg.read_shader', [shader_path], function (result) {
                                   console.log('shader result: ' + result)
                               })
                           }
                       }
                       onObjectAdded: shaderbar.insertItem(index, object)
                       onObjectRemoved: shaderbar.removeItem(object)
                   }
                   MenuSeparator {
                       visible: shaderbar.count > 0
                   }
                   /*MenuItem {
                       text: "None"
                       enabled: shaderbar.count > 0
                       onTriggered: shaderbar.clear()
                   }*/
                    MenuItem {
                        text: "None"
                        onTriggered: py.call('retroarch_cfg.read_shader', [''],
                            function (result) {console.log(result)
                       })
                   }
               }
               MenuItem {
                   id: fullscreenMenu
                   text: "Full Screen"
                   checkable: true
                   onTriggered: {
                       fullscreenMenu.checked  ? fullscreenMenu.checked = true : fullscreenMenu.checked = false
                       py.fullscreen ? py.fullscreen = "" : py.fullscreen = " -f "
                       console.log(py.fullscreen)
                   }
               }
            }
            Menu {
                id: coreMenu
                title: "Cores"
                Menu {
                    id: installedCores
                    title: "Installed"
                    Instantiator {
                        model: ListModel {id: coresModel}
                        MenuItem {
                            text: core_exists
                            onTriggered: {
                            }
                        }
                        onObjectAdded: installedCores.insertItem(index, object)
                        onObjectRemoved: installedCores.removeItem(object)
                        }
                    }
                Menu {
                    id: notInstalledCores
                    title: "All Cores"
                    Instantiator {
                        model: ListModel {id: avaiableCores}
                        MenuItem {
                            text: available
                            onTriggered: {
                            }
                        }
                        onObjectAdded: notInstalledCores.insertItem(index, object)
                        onObjectRemoved: notInstalledCores.removeItem(object)
                        }
                    }
                MenuItem {
                    id: menu
                    signal reload(string logFile)
                    text: "Custom"
                    onTriggered: {
                        LoadDialog.reloadComponent(
                                    customCoreDialog,
                                    Qt.createComponent(
                                        "CustomConsoleDialog.qml"))

                    }
                    }

            }
    }

    toolBar:
        ProgressBar {
            id: progressBar
            height: 10
            width: parent.width
            maximumValue: 80
            minimumValue: 0
            visible: false
            indeterminate: true
        }

    Loader {id: callShaderLoader}

    Component {
        id: callShaderCreator
        Python {
            Component.onCompleted: {
                var shader_path = shaders.directory
                console.log(library_path)
                addImportPath(Qt.resolvedUrl('../py/'));
                importModule('retroarch_cfg', function () {
                    call('retroarch_cfg.read_shader', [shader_path], function(result) {
                        console.log('result: ' + result)
                    })
                    }
                )
            }
        }
    }

    Loader {id: callXmlLoader}

    Component {
        id: callXmlCreator
        Python {
            Component.onCompleted: {
                var library_path = Qt.resolvedUrl(fileDialog.fileUrl)
                //importModule isnt stripping file://
                console.log(library_path)
                addImportPath(Qt.resolvedUrl('../py/'));
                importModule('xml_creator', function () {
                    call('xml_creator.scan', [library_path], function(result) {
                        libraryModel.reload()
                        progressBar.visible = false
                    })
                    }
                )
            }

    }
    }


    //Loader{id: loader}
    Rectangle {
        id: gameLayout
        anchors.top: parent.top
        anchors.bottom: settings.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        /////////////////////////////////////////////////////
        /////////          System List             //////////
        /////////////////////////////////////////////////////
        color: "#000000FF"
        ColumnLayout {
            id: leftColumn
            anchors.top: parent.top
            width: 250;
            anchors.bottom: parent.bottom
            state:  "ON"
            Rectangle {
                id: leftSide
                anchors.top: parent.top
                width: leftColumn.width; height: root.height * 0.65
                color: "#000000FF"//Controls background color
                Rectangle {
                    id: header
                    width: 250;
                    height: 25
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 2
                    anchors.right: parent.right
                    color: "#000000FF"
                    radius: 2
                    state: "ON"
                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        text: "<b>System</b>"
                        //color: "white"
                        font.pointSize: 10.5
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
                            anchors.margins: 10
                            y: filterMenu.currentItem.y;
                            color: systemPalette.highlight //Highlighter Color
                            /*gradient: Gradient {
                                GradientStop {position: 0.0; color: "#cc4d4d"}
                                GradientStop{position: 0.5; color: "#ad4141"}
                                GradientStop {position: 1.0; color: "#933b3b"}
                            }*/
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
                            PropertyChanges { target: label; color: "white"}
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
                            //opacity: 0.7
                            //color: "black";
                            x: 25
                        }
                    }   // Delegate
                }       // ListView; id: filterMenu
            }           // Rectangle; id: background
        }
            Rectangle {
                anchors.top: leftSide.bottom
                anchors.bottom: parent.bottom
                height: 50; width: parent.width
                color: "#000000FF"
                    Label {
                        id: settingsLabel
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        text: "Settings"
                        //color: systemPalette.
                        font.bold: true
                        font.pointSize: 10.5
                    }
                ColumnLayout {
                    anchors.top: settingsLabel.bottom
                    anchors.bottom: parent.bottom
                    width: parent.width
                    Rectangle {
                        id: inputButton
                        width: parent.width; height: 25
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        color: "#000000FF"
                        Label {
                            anchors.left: parent.left
                            anchors.leftMargin: 15
                            text: "Input"
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: gameLauncher.joy
                        }
                    }
                        //was shadermenu
                }
            }
        }//Rectangle: leftSide
    StackView {
        id: stackView
        anchors.top: parent.top
        anchors.bottom: parent.bttom
        anchors.left: leftColumn.right
        anchors.right: parent.right
        initialItem: gameTable
        delegate: StackViewDelegate {
                    function transitionFinished(properties)
                    {
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
        //////////////////////////////////////////////////////////////////
        /////////               Game Table View                  /////////
        //////////////////////////////////////////////////////////////////
        TableView {
            id: gameTable
            highlightOnFocus: true
            backgroundVisible: true
            model: LibraryModel {id: libraryModel}

            onDoubleClicked: {
                var core_path = gameTable.model.get(gameTable.currentRow).core
                var rom_path = gameTable.model.get(gameTable.currentRow).path

                py.call('storage.log',[[core_path, rom_path]],
                        function(result) {console.log(result)})
                py.call('retroarch_launch.launch', [rom_path, core_path,
                                                    py.fullscreen],
                        function(result) {console.log(result)})

            }
            /*headerDelegate: Rectangle {
                height: 25;
                color: leftSide.color
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: styleData.value
                    //color: "white"
                    font.bold: true
                    x: 13
                }
            }*/
            /*rowDelegate: Rectangle {
                height: 25; color: styleData.selected ?  "#b7b7b7" : "#E4E7E9"
                border.color: "lightgray"
            }*/
            /*itemDelegate: Item {
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
            }*/
            //style: TableViewStyle {
               //frame: Rectangle {
                    //color: leftSide.color
                //}
            //}
            TableViewColumn{role: "title"; title: "Name"; width: 400}
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
            TableViewColumn{role: "system"; title: "System"; width: 200}
            TableViewColumn{role: "core"; title: "Core"; width: 200}
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
            color: "white" //Grid Background Color
            //Image {
               // anchors.fill: parent;
                //source: "../images/noise.png"
            //}
            GridView {
                id: gameView
                anchors.fill: parent
                anchors.margins: 20
                cellHeight: 100 + slider.value * 2
                cellWidth: 125 + slider.value * 2
                highlight: gameHighlighter
                highlightFollowsCurrentItem: false
                focus: true
                model: libraryModel
                delegate: gameDelegate

            ////////////////////////////////////////////////////
            Component {
                id: gameHighlighter
                Rectangle {
                    opacity: 0.5
                    color: systemPalette.highlight //Highlighter Color
                    height: gameView.cellHeight; width: gameView.cellWidth
                    x: gameView.currentItem.x;
                    y: gameView.currentItem.y;
                    Behavior on x { SpringAnimation { spring: 4; damping: 0.5}}
                    Behavior on y { SpringAnimation { spring: 4; damping: 0.5}}
                }
            }
            ////////////////////////////////////////////////////
            Component {
                id: gameDelegate
                Rectangle {
                    id: gameFrame
                    width: gameView.cellWidth - 5
                    height: gameView.cellHeight - 5
                    color: "#000000FF"//gameGrid.color
                    states: State {
                        name: "Current"
                        when: gameList.ListView.isCurrentItem
                    }
                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
                        //width: parent.width * 0.8; height: parent.height * 0.8
                        color: "#000000FF"

                        Rectangle {
                            id: gameRectangle
                            color: "#000000FF"
                            anchors.fill: parent
                            anchors.centerIn: parent
                            anchors.margins: 50

                            Image {
                                id: gameImage
                                //cache: true
                                source: image
                                anchors.centerIn: parent;
                                fillMode: Image.PreserveAspectFit
                                //smooth: true
                                anchors.fill: parent
                                sourceSize.width: 500 ; sourceSize.height: 500
                                /*BorderImage {
                                    id: name
                                    source: "../images/goldborder.png"
                                    anchors.centerIn: parent
                                    width: parent.width
                                    height:parent.height
                                    border.left: 0; border.top: 0
                                    border.right: 0; border.bottom: 0
                                }*/
                           }

                           MouseArea {
                               anchors.fill: parent
                               hoverEnabled: true
                               acceptedButtons: Qt.LeftButton | Qt.RightButton

                               onDoubleClicked: {
                                   var core_path = gameView.model.get(gameView.currentIndex).core
                                   var rom_path = gameView.model.get(gameView.currentIndex).path

                                   py.call('storage.log',[[core_path, rom_path]],
                                           function(result) {console.log(result)})
                                   py.call('retroarch_launch.launch', [rom_path, core_path, py.fullscreen],
                                           function(result) {console.log(result)})
                               }
                               onClicked: {
                                   gameView.currentIndex = index;
                                   if (mouse.button === Qt.RightButton){
                                       rightClickMenu.popup()
                                   }
                                   else {
                                       console.log(gameView.model.get(gameView.currentIndex).path)
                                    }
                               }
                            }

                            // Adds game artwork to individual game
                            FileDialog {
                                id: artworkDialog
                                title: "Find Artwork"
                                nameFilters: [ "Image files (*.jpg *.png *.svg)",
                                               "All files (*)" ]
                                onAccepted: {
                                    console.log(artworkDialog.fileUrl)
                                    LoadDialog.reloadComponent(callArtworkLoader, callStoreArtwork)
                                }
                                onRejected: {
                                   console.log("Cancelled")
                                   fileDialog.close()
                                }
                            }
                            Loader {id: callArtworkLoader}

                            Component {
                                id: callStoreArtwork
                                Python {
                                    Component.onCompleted: {
                                        var artwork_path = Qt.resolvedUrl(artworkDialog.fileUrl)
                                        var title = gameView.model.get(gameView.currentIndex).title
                                        addImportPath(Qt.resolvedUrl('../py/'));
                                        console.log(artwork_path + ' ' + title)
                                        importModule('xml_creator', function () {
                                            call('xml_creator.store_artwork', [title, artwork_path], function(result) {
                                                console.log('result: ' + result)
                                                libraryModel.reload()
                                            })
                                            }
                                        )
                                    }
                                    onError: console.log(traceback)
                                }
                            }

                            Menu {
                                id: rightClickMenu
                                title: "Edit"
                                MenuItem {
                                    text: "Add Artwork"
                                    onTriggered: artworkDialog.open()
                                }
                                MenuItem {
                                    text: "Remove Artwork"
                                    onTriggered: {
                                        LoadDialog.reloadComponent(callArtworkLoader, callStoreArtwork)
                                        console.log("result: Image Removed")
                                    }
                                }
                                MenuItem {
                                    text: "Core: " + gameView.model.get(gameView.currentIndex).core
                                }
                            }

                        DropShadow{                 // Currently resizing grid
                            id: gameShadow          // takes down performance
                            //cached: true            // because shadow has to be
                            //fast: true              // redrawn everytime
                            transparentBorder: true // grid is resized
                            enabled: true
                            anchors.fill: source
                            source: gameImage
                            radius: 4
                            samples: 8
                            color: "#80000000"
                            verticalOffset: 3
                            horizontalOffset: 3
                            }
                        Label {
                            text: title
                            font.bold: true
                            font.pixelSize: 14
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
        anchors.bottom: parent.bottom
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
    statusBar:
        StatusBar{
        property alias bottomToolbar: bottomToolbar
        id: bottomToolbar

        height: 40
        //width: parent.width
        //color: "#cc4d4d"
         RowLayout {
            anchors.fill: parent
            ToolButton {
                id: gridButton
                //width: 25; height: 25
                Image {
                    id: gridImage
                    anchors.centerIn: parent
                    source: "../images/grid.png"
                }
                onClicked: {
                    function switchViews() { // Put in separate .js file
                        if (gridButton.state === "clicked") {
                            stackView.push(componentGrid)
                        }
                        else {stackView.push(gameTable)}
                    }
                    gridButton.state === "clicked" ? gridButton.state = "" : gridButton.state = "clicked"
                    switchViews()
                }
                /*MouseArea {
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
                }*/
            }
            TextField {
                id: searchBar
                width: 300; height: 30
                implicitWidth: 200
                anchors.horizontalCenter: parent.horizontalCenter

                Keys.onReturnPressed: searchBar.state = "CLOSED"
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
            }
            Slider { //Controls gameGrid icon size
                id: slider
                value: 100
                minimumValue: 50; maximumValue: 200
                implicitWidth: 100
                width: bottomToolbar.width / 6
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                /*style:
                    SliderStyle {
                        groove: Rectangle {
                            radius: 8
                            implicitHeight: 5
                            color: "white"
                        }
                        handle: Rectangle {
                            implicitWidth: 5 ;implicitHeight: 20
                            color: "white"
                        }
                    }*/
            }
        }
    }
}
