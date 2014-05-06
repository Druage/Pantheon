import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.1
import QtQuick.XmlListModel 2.0
import QtQuick.Dialogs 1.0
//import io.thp.pyotherside 1.2

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
    property string shader_cgp_path;
    property var custom_emulators;
    property var core_options;
    property var shader_data;
    property var cfg;
    property var frontend_cfg;
    property var style;
    property var defaultStyle;
    property var defaultSliderStyle;
    property var defaultSearchBarStyle;
    property string currentStyle: "OpenEmuRed";
    property bool openEmuThemeChecked;

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

    Config {
        id: config;
        Component.onCompleted: {
            frontend_cfg = readDefaultFrontEndConfigFile();
            advancedDialog._frontend_cfg = frontend_cfg;
            if (frontend_cfg["config_file"] === '""' ||
                frontend_cfg["config_file"] === undefined ||
                frontend_cfg["config_file"] === "")
                cfg = readDefaultRetroArchConfigFile();
            else {
                cfg = readConfigFile(frontend_cfg["config_file"]);
            }
            advancedDialog._cfg = cfg;
        }
    }

    onFrontend_cfgChanged: {
        if (frontend_cfg !== undefined)
            leftColumnStackView.enabled = true;
    }

    function appendConsoles(model, core_array, system) {
        for (var core in core_array)
            model.append({system: core_array[core]})
    }

    /*Python {
        id: py;
        signal pyerror(string result);
        signal status(string result);
        signal download(string result);

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../py'))
            setHandler('download', download)
            setHandler('pyerror', pyerror)
            setHandler('status', status)

            importModule('constants', function () {
                py.call('constants.shader_cgp_path', [], function (result) {
                    root.shader_cgp_path = result;
                })
            });

            importModule_sync('library');
            importModule_sync('download');
            importModule_sync('shaders');
            importModule_sync('storage');
        }

        onDownload: {
            progressBar.indeterminate = false;
            progressBar.visible = true;
            progressBar.value = result;
        }
        onStatus: {
            console.log('Status: ' + result);
            statusLabel.text = result;
            statusUpdate.visible = true;
            statusTimer.start();
        }

        onReceived: console.log('Unhandled event: ' + data);
        onPyerror: console.log('PyError: ' + result);
        onError: console.log('Error: ' + traceback);
    }*/

    Component.onCompleted: {
        defaultStyle = gameTable.style;
        defaultSliderStyle = bottomToolbar.sliderStyle;
        defaultSearchBarStyle = bottomToolbar.textFieldStyle;
    }

    Component.onDestruction: {
        config.saveFrontendConfig(frontend_cfg);
        var outfile = frontend_cfg["config_file"];
        if (outfile !== '""')
            config.saveConfig(outfile, cfg);
    }

    ListModel {id: nesModel;}
    ListModel {id: snesModel;}
    ListModel {id: n64Model;}
    ListModel {id: psxModel;}
    ListModel {id: genesisModel;}
    ListModel {id: gbModel;}
    ListModel {id: gbaModel;}
    ListModel {id: vbModel;}
    ListModel {id: arcadeModel;}
    ListModel {id: filmModel;}
    ListModel {id: indieModel;}
    ListModel {id: pcModel;}

    SystemPalette {id: systemPalette;}

    Loader {id: loader;}

    JSONListModel {
        id: _libraryModel;
        source: "library.json";
        query:  "$[*]";
    }

    CoreModel {
        id: coreModel
        onStatusChanged: {
            if (status === XmlListModel.Ready) { //Gotta add those cores!
                for (var i=0; i < count; i++) {
                    var item = get(i);
                    if (item.NES) {
                        if (item.NES.indexOf('bnes') !== -1) {
                            nesModel.append({system: item.NES, name: "bNES"})
                        }
                        else if (item.NES.indexOf('fceumm') !== -1) {
                            nesModel.append({system: item.NES, name: "FCEUmm"})
                        }
                        else if (item.NES.indexOf('nestopia') !== -1) {
                            nesModel.append({system: item.NES, name: "NEStopia"})
                        }
                        else if (item.NES.indexOf('quick') !== -1) {
                            nesModel.append({system: item.NES, name: "QuickNES"})
                        }
                        else {
                            nesModel.append({system: item.NES, name: item.NES})
                        }
                    }
                    else if (item.SNES) {
                        if (item.SNES.indexOf('bsnes_accuracy') !== -1) {
                            snesModel.append({system: item.SNES, name: "bSNES Accuracy"})
                        }
                        else if (item.SNES.indexOf('bsnes_balanced') !== -1) {
                            snesModel.append({system: item.SNES, name: "bSNES Balanced"})
                        }
                        else if (item.SNES.indexOf('bsnes_performance') !== -1) {
                            snesModel.append({system: item.SNES, name: "bSNES Performance"})
                        }
                        else if (item.SNES.indexOf('snes9x_next') !== -1) {
                            snesModel.append({system: item.SNES, name: "Snes9x Next"})
                        }
                        else if (item.SNES.indexOf('snes9x') !== -1) {
                            snesModel.append({system: item.SNES, name: "Snes9x"})
                        }
                        else {
                            snesModel.append({system: item.SNES, name: item.SNES})
                        }
                    }
                    else if (item.N64) {
                        if (item.N64.indexOf('mupen64') !== -1) {
                            n64Model.append({system: item.N64, name: "Mupen64Plus"})
                        }
                        else {
                            n64Model.append({system: item.N64, name: item.N64})
                        }
                    }
                    else if (item.PSX) {
                        if (item.PSX.indexOf('mednafen') !== -1) {
                            psxModel.append({system: item.PSX, name: "Mednafen PlayStation"})
                        }
                        else if (item.PSX.indexOf('pcsx') !== -1) {
                            psxModel.append({system: item.PSX, name: "PCSX ReArmed"})
                        }

                        else {
                            psxModel.append({system: item.PSX, name: item.PSX})
                        }
                    }
                    else if (item.VB) {
                        if (item.VB.indexOf('mednafen') !== -1) {
                            vbModel.append({system: item.VB, name: "Mednafen Virtual Boy"})
                        }
                        else {
                            vbModel.append({system: item.VB, name: "TyrQuake"})
                        }
                    }
                    else if (item.GB) {
                        if (item.GB.indexOf('gambatte') !== -1) {
                            gbModel.append({system: item.GB, name: "Gambatte"})
                        }
                        else {
                            gbModel.append({system: item.GB, name: item.GB})
                        }
                    }
                    else if (item.GBA) {
                        if (item.GBA.indexOf('vbam') !== -1) {
                            gbaModel.append({system: item.GBA, name: "Visual Boy Advance M"})
                            gbModel.append({system: item.GBA, name: "Visual Boy Advance M"})
                        }
                        else if (item.GBA.indexOf('vba') !== -1){
                            gbaModel.append({system: item.GBA, name: "Visual Boy Advance"})
                            gbModel.append({system: item.GBA, name: "Visual Boy Advance"})
                        }
                        else if (item.GBA.indexOf('meteor') !== -1){
                            gbaModel.append({system: item.GBA, name: "Meteor"})
                        }
                        else if (item.GBA.indexOf('mednafen') !== -1){
                            gbaModel.append({system: item.GBA, name: "Mednafen Game Boy Advance"})
                        }
                        else {
                            gbaModel.append({system: item.GBA, name: item.GBA})
                        }
                    }
                    else if (item.GENESIS) {
                        if (item.GENESIS.indexOf('gx') !== -1) {
                            genesisModel.append({system: item.GENESIS, name: "Genesis Plus GX"})
                        }
                        else {
                            genesisModel.append({system: item.GENESIS, name: item.GENESIS})
                        }
                    }
                    else if (item.ARCADE) {
                        if (item.ARCADE.indexOf('fb') !== -1) {
                            arcadeModel.append({system: item.ARCADE, name: "Final Burn Alpha"})
                        }
                        else if (item.ARCADE.indexOf('mame') !== -1){
                            arcadeModel.append({system: item.ARCADE, name: "Multiple Arcade Machine Emulator"})
                        }
                        else {
                            arcadeModel.append({system: item.ARCADE, name: "TyrQuake"})
                        }
                    }
                    else if (item.FILM) {
                        if (item.FILM.indexOf('ffmpeg') !== -1) {
                            filmModel.append({system: item.FILM, name: "FFmpeg"})
                        }
                        else {
                            filmModel.append({system: item.FILM, name: "TyrQuake"})
                        }
                    }
                    else if (item.PC) {
                        if (item.PC.indexOf('quake') !== -1) {
                            pcModel.append({system: item.PC, name: "TyrQuake"})
                        }
                        else {
                            pcModel.append({system: item.PC, name: "TyrQuake"})
                        }
                    }
                    else if (item.ATARI2600) {
                        if (item.ATARI2600.indexOf('stella') !== -1) {
                            filmModel.append({system: item.ATARI2600, name: "Stella"})
                        }
                        else {
                            filmModel.append({system: item.ATARI2600, name: "TyrQuake"})
                        }
                    }
                }
            }
        }
    }

    AdvancedSettings {
        id: advancedDialog;
        visible: false;
        //_defaultTableStyle: gameTable.style
        //openEmuRedTable: openEmuRed

        onClosing: {
            root.cfg = advancedDialog._cfg;
            root.frontend_cfg = advancedDialog._frontend_cfg
            if (coreModel.count <= 0) {
                coreModel.reload()
            }
        }
    }

    Component {id: openEmuRed;TableStyle {}}
    Component {id: openEmuRedSlider; SliderStyled {}}
    Component {id: openEmuRedSearchBar; SearchBarStyle {}}
    Component {id: openEmuCheckBox; CheckBoxStyled {}}

    Gradient {
        id: openEmuRedGradient;
        GradientStop {position: 0.0; color: "#cc4d4d";}
        GradientStop{position: 0.5; color: "#ad4141";}
        GradientStop {position: 1.0; color: "#933b3b";}
    }

    Gradient {
        id: openEmuRedBottomGradient
        GradientStop {position: 0.0; color: "#333333";}
        GradientStop {position: 0.3; color: "#303030";}
        GradientStop {position: 0.7; color: "#2b2b2b";}
        GradientStop {position: 1.0; color: "#262626";}
    }

    menuBar:
        TopMenuBar {id: menuBar}

    toolBar:
        ProgressBar {
            id: progressBar
            height: 10
            width: parent.width
            maximumValue: 100
            minimumValue: 0
            visible: false
            indeterminate: true
        }

    /// Creates Rectangle over ApplicationWindow
    Rectangle {
        id: gameLayout
        anchors.top: parent.top
        anchors.bottom: settings.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#000000FF"

        GameCounter {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 20
            anchors.rightMargin: 20
            height: 20
        }

        /// Status Update at Top Right Edge
        Rectangle {
            id: statusUpdate
            property string text
            z: 1
            visible: false
            radius: 6
            color: systemPalette.highlight;
            width: statusLabel.width + 15
            height: 25
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 30

            MouseArea {
                anchors.fill: parent
                onClicked: statusUpdate.visible = false
            }

            Label {
                id: statusLabel
                anchors.centerIn: parent
                color: "white"
                onLinkActivated: Qt.openUrlExternally(link)
                text: statusUpdate.text
                Timer {
                    id: statusTimer
                    interval: 5000
                    onTriggered: {statusUpdate.visible = false}
                }
            }
        }

        StackView {
            id: leftColumnStackView
            property string artworkSource
            property var gradientStyle
            property string fontColor
            property string backgroundColor: '#000000FF'
            property string borderColor: "lightgray"
            property var _frontend_cfg: root.frontend_cfg;
            enabled: false
            anchors.top: parent.top
            width: 250
            anchors.bottom: parent.bottom
            initialItem: leftColumn
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
        }

        Component {
            id: leftColumn;
            LeftConsoleList {
                artworkSource: leftColumnStackView.artworkSource
            }
        }


    StackView {
        id: stackView
        property string gridTextColor
        property string gridBackgroundColor: "white"
        property string noiseGradient: ""
        anchors.top: parent.top
        height: parent.height + 1
        anchors.left: leftColumnStackView.right
        anchors.right: parent.right
        initialItem: gameTable
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
        id: gameTable
        theme: systemPalette;
        _model: libraryModel;
        _cfg: root.cfg;
        _frontend_cfg: root.frontend_cfg;
        //_py: py
        onRowImageSourceChanged: {
            leftColumnStackView.artworkSource = rowImageSource
        }
        Component.onCompleted: console.log(root.cfg)
    }

    Component {
        id: componentGrid

        Rectangle {
            id: gameGrid
            width: 800; height: 600
            color: stackView.gridBackgroundColor //Grid Background Color

            Image {
                anchors.fill: parent
                source: stackView.noiseGradient
            }
            RomGrid {
                id: gameView
            }

            Component {
                id: gameDelegate
                    Item {
                        id: gameFrame
                        width: gameView.cellWidth
                        height: gameView.cellHeight
                        states:
                            State {
                                name: "Current"
                                when: gameList.ListView.isCurrentItem
                            }
                        Item {
                            id: gameRectangle
                            anchors.fill: parent
                            anchors.centerIn: parent
                            anchors.margins: 40
                            Image {
                                id: gameImage
                                z: gameRectangle.z + 1
                                cache: true
                                source: image
                                fillMode: Image.PreserveAspectFit
                                anchors {
                                    fill: parent;
                                    margins: 20
                                }
                                asynchronous: true
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
        }
    }
    statusBar:
        BottomStatusBar {
            id: bottomToolbar
        }
}
