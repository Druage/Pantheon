import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.1
import QtQuick.XmlListModel 2.0
import QtQuick.Dialogs 1.0
import io.thp.pyotherside 1.0
import QtQuick.Window 2.0

//import game.launcher 1.0
//import game.scan 1.0
//import xml.utils 1.0

//ON RIGHT CLICK IN GRIDVIEW BRING UP GAME DATA

ApplicationWindow {
    id: root
    width: 1024
    height: 768
    //Launcher {id: gameLauncher;}
    //ScanDirectory {id: scanDirectory;}
    //XmlLibrary {id: xmlReader}
    SystemPalette {id: systemPalette}
    menuBar:
        MenuBar {
            /*Menu {
                title: "System"
                MenuItem {
                    text: "Log"
                }
            }*/
            Menu {
                title: "Paths"
                FileDialog {
                    id: fileDialog
                    title: "Find Folder Containing Games"
                    selectFolder: true
                    onAccepted: {
                        if (callXmlLoader.sourceComponent === callXmlCreator) {
                            callXmlLoader.sourceComponent = blankComponent
                        }
                        callXmlLoader.sourceComponent = callXmlCreator
                    }
                    onRejected: {console.log("Cancelled"); fileDialog.close()}
                }

                MenuItem {
                    text: "Add Folder"
                    onTriggered: {
                        fileDialog.open()
                        libraryModel.reload()
                    }
                }
            }

            Menu {
                Loader {id: callJoyConfig}
                title: "Input"
                MenuItem {
                    text: "Configure Controller"
                    onTriggered: {
                        if (callJoyConfig.source === "CallTerminal.qml") {
                            callJoyConfig.source = "BlankComponent.qml"
                        }
                        callJoyConfig.source = "CallTerminal.qml"
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
                       property alias mode1: instan
                       model: ShaderModel {id: shaderModel}
                       MenuItem {
                           id: shaders
                           text: title
                           property var directory: path
                           onTriggered: {
                               if (callShaderLoader.sourceComponent === callShaderCreator) {
                                   callShaderLoader.sourceComponent = blankComponent
                               }
                               callShaderLoader.sourceComponent = callShaderCreator
                           }
                       }
                       onObjectAdded: shaderbar.insertItem(index, object)
                       onObjectRemoved: shaderbar.removeItem(object)
                   }
                   MenuSeparator {
                       visible: shaderbar.count > 0
                   }
                   /*MenuItem {
                       text: "Clear menu"
                       enabled: shaderbar.count > 0
                       onTriggered: shaderbar.clear()
                   }*/
               }
           }
        }

    /*toolBar:
        ProgressBar {
            id: progressBar
            height: 20
            width: parent.width
            maximumValue: 80
            minimumValue: 0
            value: 40
            style: ProgressBarStyle {
                background: Rectangle {color: '#000000FF'}
                progress: Rectangle {
                    color: systemPalette.highlight
                }
            }
        }*/

    Loader {id: callShaderLoader}

    Component {
        id: callShaderCreator
        Python {
            Component.onCompleted: {
                //gameTable.model.get(gameTable.currentRow).core
                var shader_path = shaders.directory
                //importModule isnt stripping file://
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
            //z: gameTable.z + 1
            anchors.top: parent.top
            width: 250;
            anchors.bottom: parent.bottom
            state:  "ON"
            Rectangle {
                id: leftSide
                anchors.top: parent.top
                width: leftColumn.width; height: root.height * 0.65
                color: "#000000FF"//Controls background color

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
        /*InnerShadow {
            anchors.fill:source
            source: leftColumn
            horizontalOffset: -1
            verticalOffset: -1
            radius: 8
            samples: 16
            color: "#80000000"
        }*/
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
            Loader {id: gameLaunchLoader}
            Component {
                id: callGameLaunch
                Python {
                    Component.onCompleted: {
                        var core_path = gameTable.model.get(gameTable.currentRow).core
                        var rom_path = gameTable.model.get(gameTable.currentRow).path
                        addImportPath(Qt.resolvedUrl('../py/'))
                        importModule('logger', function () {
                        importModule('retroarch_launch', function () {
                            call('retroarch_launch.launch',
                                 [rom_path, core_path], function(result) {
                                     call('logger.log', [result])
                                })
                            })
                        })
                    }
                    onError: console.log('Error: ' + traceback)
                }
            }
            Component {
                id: blankComponent
                Rectangle{
                    visible: false
                }
            }

            /*onClicked: {
                gameLaunchLoader.sourceComponent = blankComponent
            }*/
            onDoubleClicked: {
                if(gameLaunchLoader.sourceComponent === callGameLaunch) {
                    gameLaunchLoader.sourceComponent = blankComponent
                }
                gameLaunchLoader.sourceComponent = callGameLaunch

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
            color: "#000000FF" //Grid Background Color
            //Image {
               // anchors.fill: parent;
                //source: "../images/noise.png"
            //}
            GridView {
                id: gameView
                anchors.fill: parent
                anchors.margins: 20
                //: 5
                cellHeight: 250 + slider.value * 2
                cellWidth: 200 + slider.value * 2
                focus: true
                highlight: gameHighlighter
                model: libraryModel
                delegate: gameDelegate
            ////////////////////////////////////////////////////
            Component {
                id: gameHighlighter
                Rectangle {
                    opacity: 0.5
                    color: systemPalette.highlight //Highlighter Color
                    //height: 300; width: 300
                    y: gameView.currentItem.y;
                }
            }
            ////////////////////////////////////////////////////
            Component {
                id: gameDelegate
                Rectangle {
                    id: gameFrame
                    width: 175 + slider.value * 2;
                    height: 200 +  slider.value * 2
                    color: "#000000FF"//gameGrid.color
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
                            anchors.fill: parent
                            anchors.centerIn: parent
                            anchors.margins: 50

                            Image {
                                id: gameImage
                                cache: true
                                source: image
                                anchors.centerIn: parent;
                                fillMode: Image.PreserveAspectFit
                                smooth: true
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

                           Loader {id: callGridLoader}

                           Component {
                                id: callGridLaunch
                                Python {
                                    Component.onCompleted: {
                                        var core_path = gameView.model.get(gameView.currentIndex).core
                                        var rom_path = gameView.model.get(gameView.currentIndex).path
                                        addImportPath(Qt.resolvedUrl('../py/'))
                                        importModule('retroarch_launch', function () {
                                            call('retroarch_launch.launch',
                                                 [rom_path, core_path], function(result) {
                                                     console.log('Callback: ' + result)
                                                 }
                                                 )
                                            }
                                        )
                                    }
                                    onError: console.log('Error: ' + traceback)
                                }
                            }

                           MouseArea {
                               anchors.fill: parent
                               hoverEnabled: true
                               acceptedButtons: Qt.LeftButton | Qt.RightButton

                               onDoubleClicked: {
                                   gameView.currentIndex = index;
                                   console.log(callGridLoader.sourceComponent)
                                   if(callGridLoader.sourceComponent === callGridLaunch) {
                                       callGridLoader.sourceComponent = blankComponent
                                   }
                                   callGridLoader.sourceComponent = callGridLaunch
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
                                    if (callArtworkLoader.sourceComponent === callStoreArtwork) {
                                        callArtworkLoader.sourceComponent = blankComponent
                                    }
                                    callArtworkLoader.sourceComponent = callStoreArtwork
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
                                        if (callArtworkLoader.sourceComponent === callStoreArtwork) {
                                            callArtworkLoader.sourceComponent = blankComponent
                                        }
                                        callArtworkLoader.sourceComponent = callStoreArtwork
                                        console.log("result: Image Removed")
                                    }
                                }
                            }

                        DropShadow{                 // Currently resizing grid
                            id: gameShadow          // takes down performance
                            cached: true            // because shadow has to be
                            fast: true              // redrawn everytime
                            transparentBorder: true // grid is resized
                            enabled: false
                            anchors.fill: source
                            source: gameImage
                            radius: 2
                            samples: 4
                            color: "#80000000"
                            verticalOffset: 5
                            horizontalOffset: 5
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

        height: 30
        //width: parent.width
        //color: "#cc4d4d"
         RowLayout {
            anchors.fill: parent
            ToolButton {
                id: playButton
                height: 25; width: 25
                //implicitHeight: bottomToolbar.height * 0.7; implicitWidth:  25
                //color: "#000000FF"
                Image {id: playImage; anchors.fill: parent; source: "../images/play.png"}

                //MouseArea {
                    //anchors.fill: parent
                    //hoverEnabled: true
                    //onClicked: gameLauncher.launch
                //}
            }
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
            ToolButton {
                id: fullscreenButton
                width: 25; height: 25
                Image {
                    id: fullscreenImage
                    anchors.fill: parent
                    source:"../images/fullscreen.png"
                }


                //onClicked:
                /*MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: gameLauncher.fullscreen
                }*/
            }
            TextField {
                id: searchBar
                width: 300; height: 25
                implicitWidth: 200
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
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
