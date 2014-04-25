import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../js/check.js" as Check
import "../../js/parseBooleanStyle.js" as Parse

Rectangle {
    id: root;
    color: "#000000FF"
    TabView {
        count: 2
        tabsVisible: true
        anchors.fill: parent
        anchors.margins: 5
        frameVisible: true
        Tab {
            title: "Mupen64Plus"
            component: mupen64Settings;
        }
    }

    Component {
        id: mednafenPsxSettings
        MednafenPSXSettings {
        }
    }

    Component {
        id: mupen64Settings
        GridLayout {
            anchors.fill: parent
            columns: 2
            RowLayout {
                Label {text: "Cpu Core:"}
                ComboBox {
                    model: ["Dynmanic Recompiler", "Cached Interpreter", "Pure Interpreter"]
                    currentIndex: Check.coreOptions(core_options["mupen64-cpucore"]);
                    onCurrentIndexChanged: {
                        var result;
                        switch(currentIndex) {
                            case 0:
                                result = "dynmanic_recompiler";
                                break;
                            case 1:
                                result = "cached_interpreter";
                                break;
                            case 2:
                                result = "pure_interpreter";
                                break;
                            default:
                                result = "dynmanmic_recompiler";
                                console.log("Error: at mupen64settings")
                        }
                        core_options["mupen64-cpucore"] = result;
                    }
                }
            }
            RowLayout {
                Label {
                    text: "Buttons B and A"
                }
                ComboBox {
                    model: ["BA", "YB"]
                    currentIndex: Check.coreOptions(core_options["mupen64-button-orientation-ab"]);
                    onCurrentIndexChanged: {
                        var result;
                        switch(currentIndex) {
                            case 0:
                                result = "BA";
                                break;
                            case 1:
                                result = "YA";
                                break;
                            default:
                                result = "BA";
                                console.log("Error: at BA & YA")
                        }
                        core_options["mupen64-button-orientation-ab"] = result;
                    }
                }
            }
            RowLayout {
                Label {
                    text: "Player 1 Pak"
                }
                ComboBox {
                    model: ["none", "memory","rumble"]
                    currentIndex: Check.coreOptions(core_options["mupen64-pak1"]);
                    onCurrentIndexChanged: {
                        var result;
                        switch(currentIndex) {
                            case 0:
                                result = "none";
                                break;
                            case 1:
                                result = "memory";
                                break;
                            case 2:
                                result = "rumble";
                                break;
                            default:
                                result = "none";
                                console.log("Error: Rumble assignment")
                        }
                        core_options["mupen64-pak1"] = result;
                    }
                }
            }
            RowLayout {
                Label {
                    text: "Player 2 Pak"
                }
                ComboBox {
                    model: ["none", "memory","rumble"]
                    currentIndex: Check.coreOptions(core_options["mupen64-pak2"]);
                    onCurrentIndexChanged: {
                        var result;
                        switch(currentIndex) {
                            case 0:
                                result = "none";
                                break;
                            case 1:
                                result = "memory";
                                break;
                            case 2:
                                result = "rumble";
                                break;
                            default:
                                result = "";
                        }
                        core_options["mupen64-pak2"] = result;
                    }
                }
            }
            RowLayout {
                Label {
                    text: "Player 3 Pak"
                }
                ComboBox {
                    model: ["none", "memory","rumble"]
                    currentIndex: Check.coreOptions(core_options["mupen64-pak3"]);
                    onCurrentIndexChanged: {
                        var result;
                        switch(currentIndex) {
                            case 0:
                                result = "none";
                                break;
                            case 1:
                                result = "memory";
                                break;
                            case 2:
                                result = "rumble";
                                break;
                            default:
                                result = "";
                        }
                        core_options["mupen64-pak3"] = result;
                    }
                }
            }
            RowLayout {
                Label {
                    text: "Player 4 Pak"
                }
                ComboBox {
                    model: ["none", "memory","rumble"]
                    currentIndex: Check.coreOptions(core_options["mupen64-pak4"]);
                    onCurrentIndexChanged: {
                        var result;
                        switch(currentIndex) {
                            case 0:
                                result = "none";
                                break;
                            case 1:
                                result = "memory";
                                break;
                            case 2:
                                result = "rumble";
                                break;
                            default:
                                result = "";
                        }
                        core_options["mupen64-pak4"] = result;
                    }
                }
            }

            CheckBox {
                text: "Disable Expansion Ram:"
                checked: Parse.parse(core_options["mupen64-disableexpmem"])
                onCheckedChanged: {
                    if (checked) {
                        core_options["mupen64-disableexpmem"] = "yes";
                    }
                    else {
                        core_options["mupen64-disableexpmem"] = "no";
                    }
                }
            }

            RowLayout {
                Label {
                    text: "GFX Accuracy"
                }
                ComboBox {
                    model: ["low", "medium","high"]
                    currentIndex: Check.coreOptions(core_options["mupen64-gfxplugin-accuracy"]);
                    onCurrentIndexChanged: {
                        var result;
                        switch(currentIndex) {
                            case 0:
                                result = "low";
                                break;
                            case 1:
                                result = "medium";
                                break;
                            case 2:
                                result = "high";
                                break;
                            default:
                                result = "";
                        }
                        core_options["mupen64-gfxplugin-accuracy"] = result;
                    }
                }
            }
            RowLayout {
                Label {
                    text: "GFX Plugin"
                }
                ComboBox {
                    model: ["auto", "glide64","gln64", "rice"]
                    currentIndex: Check.coreOptions(core_options["mupen64-gfxplugin"]);
                    onCurrentIndexChanged: {
                        var result;
                        switch(currentIndex) {
                            case 0:
                                result = "auto";
                                break;
                            case 1:
                                result = "glide64";
                                break;
                            case 2:
                                result = "gln64";
                                break;
                            case 3:
                                result = "rice";
                                break;
                            default:
                                result = "";
                        }
                        core_options["mupen64-gfxplugin"] = result;
                    }
                }
            }
            RowLayout {
                Label {
                    text: "RSP Plugin"
                }
                ComboBox {
                    model: ["auto", "hle","cxd4"]
                    currentIndex: Check.coreOptions(core_options["mupen64-rspplugin"]);
                    onCurrentIndexChanged: {
                        var result;
                        switch(currentIndex) {
                            case 0:
                                result = "auto";
                                break;
                            case 1:
                                result = "hle";
                                break;
                            case 2:
                                result = "cxd4";
                                break;
                            default:
                                result = "";
                        }
                        core_options["mupen64-rspplugin"] = result;
                    }
                }
            }
            RowLayout {
                Label {
                    text: "Resolution"
                }
                ComboBox {
                    model: ["320x240","640x360", "640x480", "720x576",
                            "800x600", "960x540", "960x640", "1024x576",
                            "1024x768", "1280x720", "1280x768", "1280x960",
                            "1280x1024", "1600x1200", "1920x1080", "1920x1200",
                            "1920x1600", "2048x1152", "2048x1536", "2048x2048"]
                    currentIndex: Check.coreOptions(core_options["mupen64-screensize"]);
                    onCurrentIndexChanged: {
                        var result;
                        switch(currentIndex) {
                            case 0:
                                result = "320x240";
                                break;
                            case 1:
                                result = "640x360";
                                break;
                            case 2:
                                result = "640x480";
                                break;
                            case 3:
                                result = "720x576";
                                break;
                            case 4:
                                result = "800x600";
                                break;
                            case 5:
                                result = "960x540";
                                break;
                            case 6:
                                result = "960x640";
                                break;
                            case 7:
                                result = "1024x576";
                                break;
                            case 8:
                                result = "1024x768";
                                break;
                            case 9:
                                result = "1280x720";
                                break;
                            case 10:
                                result = "1280x768";
                                break;
                            case 11:
                                result = "1280x960";
                                break;
                            case 12:
                                result = "1280x1024";
                                break;
                            case 13:
                                result = "1600x1200";
                                break;
                            case 14:
                                result = "1920x1080";
                                break;
                            case 15:
                                result = "1920x1200";
                                break;
                            case 16:
                                result = "1920x1600";
                                break;
                            case 17:
                                result = "2048x1152";
                                break;
                            case 18:
                                result = "2048x1536";
                                break;
                            case 19:
                                result = "2048x2048";
                                break;
                            default:
                                result = "";
                        }
                        core_options["mupen64-screensize"] = result;
                    }
                }
            }
            RowLayout {
                Label {
                    text: "Texture Filtering"
                }
                ComboBox {
                    model: ["auto", "N64 3-point","bilinear", "nearest"]
                    currentIndex: Check.coreOptions(core_options["mupen64-filtering"]);
                    onCurrentIndexChanged: {
                        var result;
                        switch(currentIndex) {
                            case 0:
                                result = "auto";
                                break;
                            case 1:
                                result = "N64 3-point";
                                break;
                            case 2:
                                result = "bilinear";
                                break;
                            case 3:
                                result = "nearest";
                                break;
                            default:
                                result = "";
                        }
                        core_options["mupen64-filtering"] = result;
                    }
                }
            }
            RowLayout {
                Label {
                    text: "VI Refresh (Overclock)"
                }
                ComboBox {
                    model: ["1500", "2200"]
                    currentIndex: Check.coreOptions(core_options["mupen64-virefresh"]);
                    onCurrentIndexChanged: {
                        var result;
                        switch(currentIndex) {
                            case 0:
                                result = "1500";
                                break;
                            case 1:
                                result = "2200";
                                break;
                            default:
                                result = "";
                                break;
                        }
                        core_options["mupen64-virefresh"] = result;
                    }
                }
            }
            RowLayout {
                Label {
                    text: "Framerate"
                }
                ComboBox {
                    model: ["original", "fullspeed"]
                    currentIndex: Check.coreOptions(core_options["mupen64-framerate"]);
                    onCurrentIndexChanged: {
                        var result;
                        switch(currentIndex) {
                            case 0:
                                result = "original";
                                break;
                            case 1:
                                result = "fullspeed";
                                break;
                            default:
                                result = "";
                                break;
                        }
                        core_options["mupen64-framerate"] = result;
                    }
                }
            }

        }
    }
}
