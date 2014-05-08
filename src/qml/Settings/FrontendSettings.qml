import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1

Rectangle {
    id: root;

    property var _cfg;
    property var _frontend_cfg;
    property var shaders;
    //property string backgroundColor: "#000000FF"
    //property string fontColor
    //color: backgroundColor;
    color: "#000000FF"
    ColumnLayout {
        anchors.fill: parent;

        CoreModel {
            id: coreModel;
        }

        /*Label {
            anchors.left: parent.left
            anchors.margins: 20
            text: "Change Game Folder:"
            font.bold: true
        }
        RowLayout {
            id: libraryRow
            //anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.margins: 20
            height: 100
            TextField {
                id: libraryTextField
                height: 30
                anchors.left: parent.left
                anchors.right: librarySaveButton.left
                anchors.rightMargin: 10
                placeholderText: "/path/to/gamefolder"
                text: stackview.library_folder
                FileDialog {
                    id: libraryDialog
                    title: "Select Game Folder"
                    selectFolder: true
                    onAccepted:  {
                        libraryTextField.text = fileUrl
                        var folder = libraryTextField.text
                        py.call_sync("storage.ammend_cfg_data",
                                ["library_path", folder, "phoenix.cfg"])
                    }
                }

            }
            Button {
                id: librarySaveButton
                anchors.right: browseLibraryButton.left
                anchors.rightMargin: 10
                text: "Clear"
                onClicked: {
                    stackview.library_folder = ""
                    libraryTextField.text = ""
                    py.call_sync("storage.ammend_cfg_data",
                            ["library_path", "", "phoenix.cfg"])
                }
            }
            Button {
                id: browseLibraryButton
                anchors.right: parent.right
                text: "Browse"
                onClicked: libraryDialog.open()
            }
        }*/

        Label {
            anchors.left: parent.left;
            anchors.margins: 20;
            font.bold: true;
            text: "RetroArch Executable:";
        }

        RowLayout {
            id: emulatorRow;
            anchors.right: parent.right;
            anchors.left: parent.left;
            anchors.margins: 20;
            height: 100;

            TextField {
                id: emulatorTextField;
                height: 30;
                anchors.left: parent.left;
                anchors.right: emulatorSaveButton.left;
                anchors.rightMargin: 10;
                placeholderText: "/path/to/emulator.exe";
                text: (_frontend_cfg["retroarch_exe_path"] === '""') ?
                          "" : _frontend_cfg["retroarch_exe_path"];
                //textColor: fontColor;
                readOnly: true
                onTextChanged: {
                    _frontend_cfg["retroarch_exe_path"] = text;
                }

                FileDialog {
                    id: emulatorDialog;
                    title: "Select RetroArch Executable";
                    nameFilters: ["Executable file (*.exe)"];
                    onAccepted: {
                        var url = fileUrl.toString();
                        url = url.replace('file:///', '');
                        emulatorTextField.text = url;
                        url = url.replace("retroarch.exe", "");
                        var folders = library.getPaths(url);
                        if (cfgTextField.text === "") {
                            cfgTextField.text = url + "retroarch.cfg";
                        }
                        if (folders) {
                            if (coreTextField.text === "")
                                coreTextField.text = folders["cores"];
                            if (systemTextField.text === "")
                                systemTextField.text = folders["system"];
                        }
                    }
                }
            }

            Button {
                id: emulatorSaveButton;
                anchors.right: browseEmulatorButton.left;
                anchors.rightMargin: 10;
                text: "Clear";
                onClicked: {
                    _cfg["retroarch_exe_path"] = "";
                    emulatorTextField.text = "";
                }
            }

            Button {
                id: browseEmulatorButton;
                anchors.right: parent.right;
                text: "Browse";
                onClicked: emulatorDialog.open();
            }
        }

        Label {
            anchors.left: parent.left;
            anchors.margins: 20;
            font.bold: true;
            text: "Libretro Core:";
            //color: fontColor;
        }

        RowLayout {
            id: coreRow;
            anchors.right: parent.right;
            anchors.left: parent.left;
            anchors.margins: 20;
            height: 100;

            TextField {
                id: coreTextField;
                height: 30;
                anchors.left: parent.left;
                anchors.right: coreSaveButton.left;
                anchors.rightMargin: 10;
                placeholderText: "/path/to/libretro/core";
                text: (_cfg["libretro_path"] === '""') ? "" : _cfg["libretro_path"];
                //textColor: fontColor;
                readOnly: true
                onTextChanged: {
                    coreTextField.text = text
                    _cfg["libretro_path"] = text;
                    if (text !== '""') {
                        console.log("ADD CORE SCANNER");
                        /*py.call('scan.cores_quick', [text], function(result) {
                            py.call_sync('xml_creator.core_xml_writer', [result])
                        })*/
                    }
                }

                FileDialog {
                    id: coreDialog;
                    title: "Libretro Core Directory";
                    selectFolder: true;
                    nameFilters: ["Libretro corepath"];
                    onAccepted: {
                        var url = fileUrl.toString();
                        url = url.replace('file:///', '');
                        coreTextField.text = url;
                    }
                }
            }

            Button {
                id: coreSaveButton;
                anchors.right: coreEmulatorButton.left;
                anchors.rightMargin: 10;
                text: "Clear";
                onClicked: {
                    _cfg["libretro_path"] = "";
                    coreTextField.text = "";
                }
            }

            Button {
                id: coreEmulatorButton
                anchors.right: parent.right
                text: "Browse"
                onClicked: coreDialog.open()
            }
        }

        Label {
            anchors.left: parent.left
            anchors.margins: 20
            text: "System Location:"
            font.bold: true
            //color: fontColor;
        }

        RowLayout {
            id: systemRow;
            anchors.right: parent.right;
            anchors.left: parent.left;
            anchors.margins: 20;
            height: 100;

            TextField {
                id: systemTextField;
                height: 30;
                anchors.left: parent.left;
                anchors.right: systemSaveButton.left;
                anchors.rightMargin: 10;
                placeholderText: "/path/to/system.exe";
                text: (_cfg["system_directory"] === '""') ? "" : _cfg["system_directory"];
                //textColor: fontColor;
                readOnly: true
                onTextChanged: {
                    _cfg["system_directory"] = text;
                }

                FileDialog {
                    id: systemDialog;
                    title: "Select RetroArch System Folder (Holds Bios Files)";
                    selectFolder: true
                    onAccepted:  {
                        var url = fileUrl.toString();
                        url = url.replace('file:///', '');
                        systemTextField.text = url;
                    }
                }
            }

            Button {
                id: systemSaveButton;
                anchors.right: browseSystemButton.left;
                anchors.rightMargin: 10;
                text: "Clear";
                onClicked: {
                    _cfg["system_directory"] = "";
                    systemTextField.text = "";
                }
            }

            Button {
                id: browseSystemButton;
                anchors.right: parent.right;
                text: "Browse";
                onClicked: systemDialog.open();
            }
        }

        Label {
            anchors.left: parent.left
            anchors.margins: 20
            text: "Save Location:"
            font.bold: true
            //color: fontColor;
        }

        RowLayout {
            id: saveRow
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.margins: 20
            height: 100

            TextField {
                id: saveTextField
                height: 30
                anchors.left: parent.left
                anchors.right: saveSaveButton.left
                anchors.rightMargin: 10
                placeholderText: "/path/to/gamefolder"
                text: (_cfg["savefile_directory"] === '""') ? "" : _cfg["savefile_directory"];
                //textColor: fontColor;
                readOnly: true
                onTextChanged: {
                    _cfg["savefile_directory"] = text;
                    _cfg["savestate_directory"] = text;
                    console.log(_cfg["savefile_directory"]);
                }

                FileDialog {
                    id: saveDialog
                    title: "Select RetroArch Save Folder"
                    selectFolder: true
                    onAccepted:  {
                        var saveUrl = fileUrl.toString()
                        saveUrl = saveUrl.replace('file:///', '')
                        saveTextField.text = saveUrl
                    }
                }
            }

            Button {
                id: saveSaveButton
                anchors.right: saveLibraryButton.left
                anchors.rightMargin: 10
                text: "Clear"
                onClicked: {
                    _cfg["savefile_directory"] = ""
                    saveTextField.text = ""
                }
            }

            Button {
                id: saveLibraryButton
                anchors.right: parent.right
                text: "Browse"
                onClicked: saveDialog.open()
            }
        }

        Label {
            anchors.left: parent.left
            anchors.margins: 20
            text: "RetroArch Config:"
            font.bold: true
            //color: fontColor;
        }

        RowLayout {
            id: cfgRow
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.margins: 20
            height: 100

            TextField {
                id: cfgTextField
                height: 30
                anchors.left: parent.left
                anchors.right: cfgSaveButton.left
                anchors.rightMargin: 10
                placeholderText: "/path/to/retroarch.cfg"
                text: (_frontend_cfg["config_file"] === '""') ? "" : _frontend_cfg["config_file"];
                //textColor: fontColor;
                readOnly: true
                onTextChanged: {
                    _cfg["rgui_config_directory"] = text.split('/').slice(0, -1).join('/');
                    _frontend_cfg["config_file"] = text;
                }

                FileDialog {
                    id: cfgDialog
                    title: "Select Cfg File"
                    nameFilters: ["Cfg file (*.cfg)"]
                    onAccepted:  {
                        var cfgUrl = fileUrl.toString()
                        cfgUrl = cfgUrl.replace('file:///', '')
                        cfgTextField.text = cfgUrl
                    }
                }
            }

            Button {
                id: cfgSaveButton
                anchors.right: cfgLibraryButton.left
                anchors.rightMargin: 10
                text: "Clear"
                onClicked: {
                    _cfg["rgui_config_directory"] = ""
                    cfgTextField.text = ""
                }
            }

            Button {
                id:cfgLibraryButton
                anchors.right: parent.right
                text: "Browse"
                onClicked: cfgDialog.open()
            }

        }

        /*RowLayout {
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.margins: 20
            height: 50

            Label {
                text: "Disable Status Bubble (CURRENTLY NOT WORKING):"
                //color: fontColor;
            }

            Button {
                text: "Disable"
            }
        }*/

        /*RowLayout {
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.margins: 20
            height: 50
            Label {
                text: "Clear Library and Start Over:"
            }
            Button {
                text: "Clear"
                onClicked: {
                    py.call_sync('storage.reset_library', ['games.xml'])
                }
            }
        }*/

        RowLayout {
            id: backupLibrary;
            anchors.right: parent.right;
            anchors.left: parent.left;
            anchors.margins: 20;
            height: 50;

            Label {
                text: "Backup Library:";
                //color: fontColor;
            }

            Button {
                text: "Backup";
            }
        }

        RowLayout {
            id: restoreLibrary;
            anchors.right: parent.right;
            anchors.left: parent.left;
            anchors.margins: 20;
            height: 50;

            Label {

                text: "Restore Library:";
                //color: fontColor;
            }

            TextField {
                id: restoreTextField
                height: 30
                anchors.right: restoreButton.left
                anchors.rightMargin: 10
            }

            FileDialog {
                id: restoreDialog;
                title: "Select Library File";
                nameFilters: ["Library file (*.json)"];
                onAccepted:  {
                    var cfgUrl = fileUrl.toString();
                    cfgUrl = cfgUrl.replace('file:///', '');
                    restoreTextField.text = cfgUrl;
                }
            }

            Button {
                id: restoreButton;
                text: "Restore";
                onClicked: {
                    restoreDialog.open();
                }
            }

        }
    }
}
