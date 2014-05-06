import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.1

import "../../js/load_dialog.js" as LoadDialog
import "../../js/check.js" as Check
import "../../js/parseBooleanStyle.js" as ParseBool

MenuBar {
    id: menuBar;
    /*br4xHybridMenu.value = shader_data["4xbr_hybrid"]
    crtMenu.value = shader_data["crt"]
    crtGeomFlatMenu.value = shader_data["crt_geom_flat"]
    crtGeomFlatSharpMenu.value = shader_data["crt_geom_flat_sharpness"]
    crtGeomArcadeTiltMenu.value = shader_data["crt_geom_arcadetilt"]
    crtGeomCurvedMenu.value = shader_data["crt_geom_curved"]
    gtuMenu.value = shader_data["gtu"]
    hyllianMenu.value = shader_data["crt_hyllian"]
    phosphorLutMenu.value = shader_data["phosphor_lut"]
    phosphorMenu.value = shader_data["phosphor"]
    phosphorNormalGammaMenu.value = shader_data["phosphor_normalgamma"]
    phosphorTrailsMenu.value = shader_data["phosphor_trails"]*/
    Menu {
        title: "System"

        MenuItem {
            text: "Delete RetroArch"
            onTriggered: {
                console.log("ADD DELETE RETROARCH FUNCTION");
            }
        }

        MenuItem {
            text: "Clear Library"
            onTriggered: {
                console.log("deleted: " + library.deleteLibraryFile());
                libraryModel.clear();
            }
        }

        MenuItem {
            text: "Advanced"
            onTriggered: {
                advancedDialog.visible = true;
                root.cfg = advancedDialog.stack_cfg;
                root.frontend_cfg = advancedDialog.stack_frontend_cfg;
            }
        }
    }

    Menu {
        title: "Paths";
        FileDialog {
            id: fileDialog;
            title: "Add a Single Folder or an Entire Directory";
            selectFolder: true;
            onAccepted: {
                var url = fileUrl.toString().replace('file:///', '');
                progressBar.visible = true;
                progressBar.indeterminate = true;
                libraryModel.clear();
                if (library.scanRecursively(url, "library.json"))
                    _libraryModel.reload();
                progressBar.visible = false;
            }
        }

        MenuItem {
            text: "Add Folder"
            onTriggered: {
                fileDialog.open()
            }
        }

    }

    /*Menu {
        title: "Input"

        MenuItem {
            text: "Configure Controller"
            onTriggered: {
                py.call('call_joyconfig.call', [], function (result) {
                    console.log("result: " + result)
                })
            }
        }
    }*/

    /*Menu {
        title: "Video"

        MenuItem {
            text: "Advanced"
        }
    }*/

    Menu {
        id: shaderbar;
        title: "Shaders";

        ExclusiveGroup {
            id: shaderGroup;
            property string shaderFile;
            onShaderFileChanged: {
                root.cfg['video_shader'] = shader_cgp_path;
                console.log(shaderFile)
                py.call_sync("shaders.write_shader", [shaderFile]);
            }
        }

        MenuItem {
            text: "3dfx (NOT WORKING)"
            property string value: "3dfx/3dfx_4x1.cgp";
            exclusiveGroup: shaderGroup;
            checkable: true;
            onTriggered: {
                shaderGroup.shaderFile = value;
            }
        }

        Menu {
            title: "Crt";

            MenuItem {
                id: br4xHybridMenu;
                text: "4x Br Hybrid";
                property string value: "crt/4xbr-hybrid-crt.cg";
                checkable: true;
                exclusiveGroup: shaderGroup;
                onTriggered: {
                    shaderGroup.shaderFile = value;
                }
            }
            MenuItem {
                id: crtMenu;
                text: "Crt";
                property string value: "crt/crt.cg";
                checkable: true;
                exclusiveGroup: shaderGroup;
                onTriggered: {
                    shaderGroup.shaderFile = value;
                }
            }
            MenuItem {
                text: "Crt Caligari";
                property string value: "crt/crt-caligari.cg";
                checkable: true;
                exclusiveGroup: shaderGroup;
                onTriggered: {
                    shaderGroup.shaderFile = value;
                }
            }
            Menu {
                title: "Crt Geometry";
                MenuItem {
                    id: crtGeomFlatMenu;
                    text: "Flat";
                    checkable: true;
                    exclusiveGroup: shaderGroup;
                    property string value: "crt/crt-geom-flat.cg";
                    onTriggered: {
                        shaderGroup.shaderFile = value;
                    }
                }
                MenuItem {
                    id: crtGeomFlatSharpMenu
                    text: "Flat (Sharp)"
                    checkable: true
                    exclusiveGroup: shaderGroup
                    property string value: "crt/crt-geom-flat-sharpness.cg";
                    onTriggered: {
                        shaderGroup.shaderFile = value;
                    }
                }
                MenuItem {
                    id: crtGeomArcadeTiltMenu
                    text: "Arcade Tilt"
                    checkable: true
                    exclusiveGroup: shaderGroup
                    property string value: "crt/crt-geom-arcadetilt.cg";
                    onTriggered: {
                        shaderGroup.shaderFile = value;
                    }
                }
                MenuItem {
                    id: crtGeomCurvedMenu
                    text: "Curved"
                    checkable: true
                    exclusiveGroup: shaderGroup
                    property string value: "crt/crt-geom-curved.cg";
                    onTriggered: {
                        shaderGroup.shaderFile = value;
                    }
                }
            }

            MenuItem {
                id: gtuMenu
                text: "GTU (NOT WORKING)"
                checkable: true
                exclusiveGroup: shaderGroup
                property string value: "gtu-v050/gtuv50.cgp";
                onTriggered: {
                    shaderGroup.shaderFile = value;
                }
            }
            MenuItem {
                id: hyllianMenu
                text: "Hyllian (NOT DONE)"
                checkable: true
                exclusiveGroup: shaderGroup
                property string value;
                onTriggered: {
                    shaderGroup.shaderFile = value;
                }
            }
            MenuItem {
                id: interlacedHalationMenu
                text: "Interlaced Halation (NOT WORKING)"
                checkable: true
                exclusiveGroup: shaderGroup
                property string value: "crt/crt-interlaced-halation/crt-interlaced-halation.cgp";
                onTriggered: {
                    shaderGroup.shaderFile = value;
                }
            }
            Menu {
                title: "Phosphor"
                MenuItem {
                    id: phosphorLutMenu;
                    text: "Lut v2.2";
                    checkable: true;
                    exclusiveGroup: shaderGroup;
                    property string value: "crt/phosphor-v2.2/phosphorlut.cgp";
                    onTriggered: {
                        shaderGroup.shaderFile = value;
                    }
                }
                MenuItem {
                    id: phosphorTrailsMenu
                    text: "Trails"
                    checkable: true
                    exclusiveGroup: shaderGroup
                    property string value: "crt/phosphor-trails.cg";
                    onTriggered: {
                        shaderGroup.shaderFile = value;
                    }
                }
                MenuItem {
                    id: phosphorNormalGammaMenu;
                    text: "Normal Gamma";
                    checkable: true;
                    exclusiveGroup: shaderGroup;
                    property string value: "crt/phosphor-normalgamma.cg";
                    onTriggered: {
                        shaderGroup.shaderFile = value;
                    }
                }
                MenuItem {
                    id: phosphorMenu;
                    text: "Phosphor";
                    checkable: true;
                    exclusiveGroup: shaderGroup;
                    property string value: "crt/phosphor.cg";
                    onTriggered: {
                        shaderGroup.shaderFile = value;
                    }
                }
            }
            MenuItem {
                text: "Reverse AA (NOT DONE)"
                checkable: true
                exclusiveGroup: shaderGroup
            }
        }
        Menu {
            title: "Dithering (NOT DONE)"
            MenuItem {
                text: "Cbod v1 (NOT DONE)"
                checkable: true
                exclusiveGroup: shaderGroup
            }

            Menu {
                title: "Mdapt v2.7 (NOT DONE)"
                MenuItem {
                    text: "Mdapt"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
                MenuItem {
                    text: "Mdapt xBr Hybrid AA"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
                MenuItem {
                    text: "Mdapt xBr Hybrid DDT"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
            }
            Menu {
                title: "Gdapt v1.2 (NOT DONE)"
                MenuItem {
                    text: "Gdapt"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
                MenuItem {
                    text: "Gdapt xBr Hybrid AA"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
                MenuItem {
                    text: "Gdapt xBr Hybrid DDT"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
            }
        }

        Menu {
            title: "Hqx"
            MenuItem {
                property string value: "hqx/hq4x.cg";
                text: "Hq4x"
                checkable: true
                exclusiveGroup: shaderGroup
                onTriggered: {
                    shaderGroup.shaderFile = value;
                }
            }
            MenuItem {
                property string value: "hqx/hq2x.cg";
                text: "Hq2x"
                checkable: true
                exclusiveGroup: shaderGroup
                onTriggered: {
                    shaderGroup.shaderFile = value;
                }
            }
        }
        Menu {
            title: "Handheld (NOT DONE)"
            Menu {
                title: "Dmg"
                MenuItem {
                    text: "2x"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
                MenuItem {
                    text: "3x"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
                MenuItem {
                    text: "4x"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
            }
            MenuItem {
                text: "Game Boy"
                checkable: true
                exclusiveGroup: shaderGroup
            }
            Menu {
                title: "LCD Cgwg (NOT DONE)"
                MenuItem {
                    text: "Cgwg"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
                MenuItem {
                    text: "Grid"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
                MenuItem {
                    text: "Simple Motionblur"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
            }
            MenuItem {
                text: "LCD (NOT DONE)"
                checkable: true
                exclusiveGroup: shaderGroup
            }
            MenuItem {
                text: "LCD 3x"
                property string value: "handheld/lcd3x.cg"
                checkable: true;
                exclusiveGroup: shaderGroup;
                onTriggered: {
                    shaderGroup.shaderFile = value;
                }
            }
            MenuItem {
                property string value: "handheld/dot.cg";
                text: "Dot";
                checkable: true;
                exclusiveGroup: shaderGroup;
                onTriggered: {
                    shaderGroup.shaderFile = value;
                }
            }
        }
        Menu {
            title: "Ntsc (NOT DONE)"
            Menu{
                title: "256px (NOT DONE)"
                MenuItem {
                    text: "256px"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
                MenuItem {
                    text: "Gauss Scanline"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
                MenuItem {
                    text: "SVideo"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
                MenuItem {
                    text: "SVideo Gauss Scanline"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
            }
            Menu{
                title: "320px (NOT DONE)"
                MenuItem {
                    text: "320px"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
                MenuItem {
                    text: "SVideo"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
                MenuItem {
                    text: "SVideo Gauss Scanline"
                    checkable: true
                    exclusiveGroup: shaderGroup
                }
            }
            MenuItem {
                text: "Ntsc (NOT DONE)"
                checkable: true
                exclusiveGroup: shaderGroup
            }
            MenuItem {
                text: "Stock (NOT DONE)"
                checkable: true
                exclusiveGroup: shaderGroup
            }
            MenuItem {
                text: "SVideo (NOT DONE)"
                checkable: true
                exclusiveGroup: shaderGroup
            }

        }
        Menu {
            title: "Motion Blur";
            MenuItem {
                property string value: "motionblur/braid-rewind.cg";
                text: "Braid Rewind";
                checkable: true;
                exclusiveGroup: shaderGroup;
                onTriggered: {
                    shaderGroup.shaderFile = value;
                }
            }
            MenuItem {
                property string value: "motionblur/motionblur-blue.cg";
                text: "Blue";
                checkable: true;
                exclusiveGroup: shaderGroup;
                onTriggered: {
                    shaderGroup.shaderFile = value;
                }
            }
            MenuItem {
                property string value: "motionblur/motionblur-simple.cg";
                text: "Simple";
                checkable: true;
                exclusiveGroup: shaderGroup;
                onTriggered: {
                    shaderGroup.shaderFile = value;
                }
            }
        }


        MenuItem {
            property string value: "pixellate.cg";
            text: "Pixellate";
            checkable: true;
            exclusiveGroup: shaderGroup;
            onTriggered: {
                shaderGroup.shaderFile = value;
            }
        }
        MenuItem {
            property string value: "scanline.cg";
            text: "Scanline";
            checkable: true;
            exclusiveGroup: shaderGroup;
            onTriggered: {
                shaderGroup.shaderFile = value;
            }
        }
        MenuItem {
            property string value: "sharp-bilinear.cg";
            text: "Sharp Bilinear";
            checkable: true;
            exclusiveGroup: shaderGroup;
            onTriggered: {
                shaderGroup.shaderFile = value;
            }
        }
        MenuItem {
            property string value: "eagle/super-eagle.cg";
            text: "Super Eagle";
            checkable: true;
            exclusiveGroup: shaderGroup;
            onTriggered: {
                shaderGroup.shaderFile = value;
            }
        }

        Instantiator {
            id: instan
            model: ListModel {id: shaderModel}
            MenuItem {
                id: shaders
                text: shader_path
                //property var directory: path
                onTriggered: {
                    py.call('retroarch_cfg.read_shader', [shader_path], function (result) {
                        console.log('shader result: ' + result)})
                }
            }
            onObjectAdded: shaderbar.insertItem(index, object)
            onObjectRemoved: shaderbar.removeItem(object)
        }
        MenuSeparator {
            visible: shaderbar.count > 0
        }
        MenuItem {
            text: "None"
            onTriggered: {
                shaderGroup.shaderFile = "";
            }
        }
    }

    Menu {
        id: themeMenu
        title: "Themes"
        MenuItem {
            text: "OpenEmu (Red) (I BROKE IT, WILL BE FIXED DURING PROPER RELEASE)"
            checkable: true
            onTriggered: {
                if(currentStyle === "OpenEmuRed") {
                    checked = true
                    stackView.gridTextColor = "#e1e0e0"
                    stackView.noiseGradient = "../images/noise.png"
                    stackView.gridBackgroundColor = "#393939"
                    stackView.anchors.right = undefined
                    //stackView.Layout.fillWidth: true
                    gameTable.style = openEmuRed;
                    bottomToolbar.textFieldStyle = openEmuRedSearchBar
                    bottomToolbar.sliderStyle = openEmuRedSlider
                    bottomToolbar.color = "#333333"
                    bottomToolbar.gradient = openEmuRedBottomGradient
                    currentStyle = "red";
                    leftColumnStackView.backgroundColor = "#3f3f3f"
                    leftColumnStackView.gradientStyle = openEmuRedGradient
                    leftColumnStackView.fontColor = "#e1e0e0"
                    leftColumnStackView.borderColor = "#000000"
                    //advancedDialog._defaultTableStyle = openEmuRed
                    //treeview.highlightColor = "red"
                    //advancedDialog.defaultVideoStyle = "#262626"
                    //advancedDialog.videoTextColor = "#e1e0e0"

                }
                else {
                    checked = false
                    stackView.gridTextColor = ""
                    stackView.noiseGradient = ""
                    stackView.gridBackgroundColor = "white"
                    stackView.anchors.right = gameLayout.right
                    gameTable.style = defaultStyle;
                    currentStyle = "OpenEmuRed"
                    //gameTable.style = undefined
                    leftColumnStackView.backgroundColor = "white"
                    bottomToolbar.sliderStyle = defaultSliderStyle
                    bottomToolbar.textFieldStyle = defaultSearchBarStyle
                    bottomToolbar.color = "white"
                    bottomToolbar.gradient = undefined
                    leftColumnStackView.gradientStyle = undefined
                    leftColumnStackView.fontColor = "black"
                    leftColumnStackView.borderColor = "lightgray"
                   // advancedDialog._defaultTableStyle = defaultStyle
                    //advancedDialog.defaultVideoStyle = "#000000FF"
                    //advancedDialog.videoTextColor = "black"
                }
                openEmuThemeChecked = checked
            }
        }
    }
    Menu {
        title: "About";

        License {id: license; visible: false;}
        Credit {id: credit; visible: false;}

        MenuItem {
            text: "License";
            onTriggered: license.visible = true;
        }
        MenuItem {
            text: "Credit"
            onTriggered: credit.visible = true;
        }
        Menu {
            title: "Version"
            MenuItem {
                text: "Phoenix v0.9"
            }
        }
    }
}
