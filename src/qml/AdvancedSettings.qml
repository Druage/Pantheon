import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.XmlListModel 2.0
//import io.thp.pyotherside 1.2

import "Settings"

import "../js/toggleChecked.js" as ToggleChecked
import "../js/parseBooleanStyle.js" as ParseBool
import "../js/check.js" as Check

//screenshot_directory = "C:\Qt\Qt5.2.1"
//system_directory = "C:\Program Files\7-Zip"
//savestate_directory = "C:\Go\api"
//rgui_browser_directory = "D:\ROMS\Emulation"
//video_shader_dir = "C:\AMD"


ApplicationWindow {
    id: root
    title: qsTr("Advanced Settings")
    width: 720
    height: 480
    minimumWidth: 600
    minimumHeight: 460
    modality: Qt.ApplicationModal;
    visible: true

   // property var checkBoxStyle
    //property string videoTextColor
    //property string defaultVideoStyle
    //property var _defaultTableStyle
    //property Component openEmuRedTable
    property var _cfg//: stackview.cfg
    property var _frontend_cfg//: stackview.frontend_cfg

    function check_driver(variable) {
        if (variable === "gl") {
            return 0
        }
        else if (variable === "d3d9") {
            return 1
        }
        else if (variable === "sdl") {
            return 2
        }
        else if (variable === "dsound") {
            return 0
        }
        else if (variable === "rsound") {
            return 1
        }
        else if (variable === "xaudio") {
            return 3
        }
    }

    /*onClosing: {
        var custom_emulator_title;
        if (custom_emulators['title'] !== "") {
            custom_emulator_title = custom_emulators['title'].replace(/\s+/g, '') + '.cfg';
            py.call_sync("storage.json_to_cfg", ['.retroarch-core-options.cfg', core_options])
            py.call_sync("storage.save_custom_emulators", [custom_emulator_title, custom_emulators]);
        }
    }*/

//e3ce1f
    toolBar:
        ToolBar {
            id: toolbar
            height: 30
            /*Component.onCompleted: toolbar.data[0].item.children = [newRectangle];
                    property Item _newRectangle: Rectangle {
                        // The rectangle within the ToolBarStyle's panel
                        // Gleaned from:
                        // http://qt.gitorious.org/qt/qtquickcontrols/source/
                        //   c304d741a27b5822a35d1fb83f8f5e65719907ce:src/styles/Base/ToolBarStyle.qml
                        id: newRectangle
                        anchors.fill: parent
                        gradient: Gradient{
                            GradientStop {position: 0.0; color: "#4a4a4a"}
                        }
                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 1
                            color: "#999"
                        }
                    }*/
            RowLayout {
                anchors.fill: parent;
                ToolButton {
                    text: "Info";
                    onClicked: {
                        stackview.clear();
                        stackview.push(info);
                    }
                }
                ToolButton {
                    text: "Library"
                    onClicked: {
                        stackview.clear();
                        stackview.push(frontend);
                    }
                }
                ToolButton {
                    text: "Input"
                    onClicked: {
                        stackview.clear();
                        stackview.push(input);
                    }
                }
                ToolButton {
                    text: "Video"
                    onClicked:{
                        stackview.clear();
                        stackview.push(video);
                    }
                }
                ToolButton {
                    text: "Audio"
                    onClicked: {
                        stackview.clear();
                        stackview.push(audio);
                    }
                }
                /*ToolButton {
                    text: "Cores"
                    onClicked: {
                        stackview.clear();
                        stackview.push(cores);
                    }
                }
                ToolButton {
                    text: "Emulators"
                    onClicked: {
                        stackview.clear();
                        stackview.push(emulators);
                    }
                }*/
            }
        }

    Component {
        id: info
        InfoSettings {
            //defaultStyle: _defaultTableStyle
        }
    }

    Component {
        id: audio
        AudioSettings {
            cfg: _cfg;
            //backgroundStyle: defaultVideoStyle;
            //fontColor: videoTextColor
            //checkBoxStyle: root.checkBoxStyle
        }
    }

    Component {
        id: input
        InputSettings {

        }
    }

    Component {
        id: video
        VideoSettings {
            cfg: _cfg;
            frontend_cfg: _frontend_cfg;
            //_py: py;
            //checkBoxStyle: root.checkBoxStyle;
            //_defaultVideoStyle: defaultVideoStyle;
            //_videoTextColor: videoTextColor;
            //_shaderMo;del;
        }
    }

    Component {
        id: frontend
        FrontendSettings {
            _cfg: root._cfg
            _frontend_cfg: root._frontend_cfg
            //backgroundColor: defaultVideoStyle
            //fontColor: videoTextColor
            //property var shaders
        }
    }

    Component {
        id: emulators
        EmulatorSettings {
            //defaultStyle: _defaultTableStyle
        }
    }


    StackView {
        id: stackview
        anchors.fill: parent
        initialItem: info

        property var cfg: root._cfg
        property var frontend_cfg: root._frontend_cfg

        /*Python {
            id: py

            Component.onCompleted: {
                addImportPath(Qt.resolvedUrl('../py'));
                importModule_sync('storage');
                importModule_sync('scan');
                importModule_sync('xml_creator');
            }
        }*/
    }
}
