import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1

import "../Themes/OpenEmu (Red)/CheckBoxStyled"
import "../../js/parseBooleanStyle.js" as ParseBool
import "../../js/check.js" as Check

ColumnLayout {
    id: root;
    property var cfg;
    property var frontend_cfg;
    //property var _py;
    property var _shaderModel;
    //property var _defaultVideoStyle
   // property string _videoTextColor
   //// property Component checkBoxStyle
    //property var defaultCheckBoxStyle

    Component.onCompleted: {
        //_py.importModule_sync('shaders')
        //_py.importModule_sync('xml_creator')
    }

    ShaderModel {
        id: shaderModel;
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000FF"//_defaultVideoStyle
        Label {
            anchors.left: parent.left;
            anchors.leftMargin: 10;
            anchors.bottom: shaderColumn.top;
            anchors.bottomMargin: 5;
            text: "Shaders:";
            font.bold: true;
            //color: _videoTextColor
        }

        ColumnLayout {
            id: shaderColumn;
            anchors.left: parent.left;
            anchors.right: parent.right;

        Label {
            anchors {
                left: parent.left;
                leftMargin: 10;
                bottom: videoColumn.top;
                bottomMargin: 5;
            }
            text: "Video:";
            font.bold: true;
            //color: _videoTextColor
        }

        ColumnLayout {
            id: videoColumn;
            anchors.left: parent.left;
            anchors.leftMargin: 40;

            RowLayout {
                Label {
                    text: "Video Driver:";
                    //color: _videoTextColor
                }

                ComboBox {
                    id: driverCombo
                    model: ["OpenGL", "DirectX", "SDL"]
                    currentIndex: check_driver(cfg["video_driver"])
                    onCurrentTextChanged: {
                        var driver_val = ""
                        if (driverCombo.currentText === "DirectX") {
                            driver_val = 'd3d9'
                        }
                        else if (driverCombo.currentText === "SDL") {
                            driver_val = 'sdl'
                        }
                        else {
                            driver_val = 'gl'
                        }
                        cfg["video_driver"] = driver_val
                    }
                }
            }

            CheckBox {
                id: fullscreenCheck
                text: "Fullscreen"
                checked: ParseBool.parse(cfg["video_fullscreen"])
                onCheckedChanged: {
                    cfg["video_fullscreen"] = Check.checked_is(checked);
                }
            }

            CheckBox {
                id: shaderCheck
                text: "Video Shader"
                checked: ParseBool.parse(cfg["video_shader_enable"])
                onCheckedChanged: {
                    cfg["video_shader_enable"] = Check.checked_is(checked);
                }
            }

            CheckBox {
                id: vsyncCheck
                text: "VSync"
                checked: ParseBool.parse(cfg["video_vsync"])
                onClicked: {
                    cfg["video_vsync"] = Check.checked_is(checked)
                }
            }

            CheckBox {
                id: scaleCheck
                text: "Integer Scale"
                checked: ParseBool.parse(cfg["video_scale_integer"])
                onClicked: {
                    cfg["video_scale_integer"] = Check.checked_is(checked)
                }
            }

            CheckBox {
                id: threadCheck
                text: "Threaded Driver"
                checked: ParseBool.parse(cfg["video_threaded"])
                onClicked: {
                    cfg["video_threaded"] = Check.checked_is(checked)
                }
            }

            CheckBox {
                id: cropCheck
                text: "Crop Overscan"
                checked: ParseBool.parse(cfg["video_crop_overscan"])
                onClicked: {
                    cfg["video_crop_overscan"] = Check.checked_is(checked)
                }
            }

            CheckBox {
                id: fpsCheck
                text: "Show Framerate"
                checked: ParseBool.parse(cfg["fps_show"])
                onClicked: {
                    cfg["fps_show"] = Check.checked_is(checked)
                }
            }

            CheckBox {
                id: bilinearCheck
                text: "Bilinear Filter"
                checked: ParseBool.parse(cfg["video_smooth"])
                onClicked: {
                    cfg["video_smooth"] = Check.checked_is(checked)
                }
            }

            RowLayout {

                Label {
                    text: "Custom Ratio: (CURRENTLY NOT WORKING)";
                    //color: _videoTextColor;
                }

                TextField {}
            }

            RowLayout {

                Label {
                    text: "Windowed Scale (X):";
                    //color: _videoTextColor;
                }

                ComboBox {
                    id: scaleXCombo
                    model: [1.0, 2.0, 3.0, 4.0, 5.0]

                    currentIndex: (parseInt(cfg["video_xscale"]) - 1)
                    onCurrentTextChanged: {
                        cfg["video_xscale"] =
                                parseFloat(scaleXCombo.currentText).toFixed(6);
                    }
                }
            }

            RowLayout {

                Label {
                    text: "Windowed Scale (Y):";
                   // color: _videoTextColor;
                }

                ComboBox {
                    id: scaleYCombo
                    model: [1.0, 2.0, 3.0, 4.0, 5.0]
                    currentIndex: (parseInt(cfg["video_yscale"]) - 1)
                    onCurrentTextChanged: {
                        cfg["video_yscale"] =
                                parseFloat(scaleYCombo.currentText).toFixed(6);
                    }
                }
            }

            RowLayout {
                Label {
                    text: "Rotation:";
                    //color: _videoTextColor;
                }
                ComboBox {
                    id: rotationCombo;
                    model: ["Normal", "90 deg", "180 deg", "270 deg"];
                    currentIndex: (parseInt(cfg["video_rotation"]));
                    onCurrentIndexChanged: {
                        cfg["video_rotation"] = currentIndex;
                    }
                }
           }
        }
    }
    }
}
