import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.XmlListModel 2.0

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

    toolBar:
        ToolBar {
            id: toolbar
            height: 30
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
            }
        }

    Component {
        id: info
        InfoSettings {}
    }

    Component {
        id: audio
        AudioSettings {
            cfg: _cfg;
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
        }
    }

    Component {
        id: frontend
        FrontendSettings {
            _cfg: root._cfg
            _frontend_cfg: root._frontend_cfg

        }
    }

    Component {
        id: emulators
        EmulatorSettings {}
    }


    StackView {
        id: stackview
        anchors.fill: parent
        initialItem: info
    }
}
