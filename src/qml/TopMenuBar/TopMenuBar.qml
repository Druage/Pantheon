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
                if (library.deleteLibraryFile())
                    statusUpdate.text = "Library Deleted";
                else
                    statusUpdate.text = "Library Doesn't Exist"
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
                if (library.scanRecursively(url, "library.json")) {
                    _libraryModel.reload();
                    statusUpdate.text = "Library Imported";
                }
                progressBar.visible = false;
            }
        }

        MenuItem {
            text: "Add Folder"
            onTriggered: {
                fileDialog.open();
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
