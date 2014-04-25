import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import io.thp.pyotherside 1.2

import "../../js/check.js" as Check

TableView {
    id: root;
    property var theme;
    property var _model;
    property var _cfg;
    property var _frontend_cfg;
    property var _py
    property var rowImageSource
    backgroundVisible: true;
    alternatingRowColors: true;
    model: _model;

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../../py'))
            importModule_sync('retroarch_launch')
        }
    }

    function compareSystem(system) {
        var result = "";
        var index;
        switch(system) {
            case "Nintendo Entertainment System":
                result = cfg["core_nes"];
                break;
            case "Super Nintendo":
                result = cfg["core_snes"];
                break;
            case "Nintendo 64":
                result = cfg["core_n64"];
                break
            case "Game Boy":
            case "Game Boy Color":
                result = cfg["core_gb"];
                break
            case "Game Boy Advance":
                result = cfg["core_gba"];
                break;
            case "Sony PlayStation":
                result = cfg["core_psx"];
                break
            case "Arcade":
                result = cfg["core_arcade"];
                break
            case "Virtual Boy":
                result = cfg["core_vb"];
                break
            case "Computer":
                result = cfg["core_pc"];
                break
            case "Sega Genesis":
                result = cfg["core_gen"];
                break
            case "Film":
                result = cfg["core_film"];
                break
            case "Indie":
                result = cfg["core_indie"];
                break
            default:
                result = "System was not assigned"
                break;
        }
        return result;
    }


    Menu {
        id: rightTableMenu
        title: "Edit"
        MenuItem {
            text: "Compress"

        }
        MenuItem {
            text: "Open Game Location"
        }
        MenuItem {
            text: "Remove"
        }
    }

    onCurrentRowChanged: {
        root.rowImageSource = root.model.get(root.currentRow).image
    }

    Menu {
        id: tableRightClickMenu
        title: "Menu"
        MenuItem {
            text: "MenuMEnu"
        }
    }

    onDoubleClicked: {
        var rom_path = root.model.get(root.currentRow).path;
        var core_file = compareSystem(root.model.get(root.currentRow).console);
        var core_path = cfg["libretro_path"] + '/' + core_file;

        if (cfg["exe_path"] === "" ||
            cfg["cfg_file"] === "" ||
            core_path === '\n' ) {
            statusUpdate.visible = true;
            statusUpdate.text = "You must provided paths for the RetroArch executable, cores, and config";
            statusTimer.start();
        }

        else {
            if (frontend_cfg["config_file"] !== "") {
                py.call("storage.json_to_cfg", [frontend_cfg["config_file"], cfg], function (result) {
                    console.log(result)
                    if (result) {
                        py.call_sync('retroarch_launch.launch',
                                     [cfg["retroarch_exe_path"],
                                      rom_path,
                                      core_path,
                                      frontend_cfg["config_file"]]
                                    )
                    }
                })
            }
        }
    }

    TableViewColumn{role: "title"; title: "Name"; width: 400}
    TableViewColumn{role: "console"; title: "System"; width: 200}
    //TableViewColumn{role: "core"; title: "Core"; width: 200}
    TableViewColumn{role: "valid"; title: "Valid"; width: 200}

}
