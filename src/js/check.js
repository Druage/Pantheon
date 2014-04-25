function checked_is(prop) {
    if (prop === true) {return "true"}
    else {return "false"}
}

function core(system, cfg_obj) {
    var file = undefined;
    if (system === "Nintendo 64") {
        file = cfg_obj["core_n64"];
    }
    else if (system === "Super Nintendo") {
        file = cfg_obj["core_snes"];
    }
    else if (system === "Nintendo") {
        file = cfg_obj["core_nes"];
    }
    else if (system === "Sony PlayStation") {
        file = cfg_obj["core_psx"];
    }
    else if (system === "Virtual Boy") {
        file = cfg_obj["core_vb"];
    }
    else if (system === "Game Boy" || system === "Game Boy Color") {
        file = cfg_obj["core_gb"];
    }
    else if (system === "Game Boy Advance") {
        file = cfg_obj["core_gba"];
    }
    else if (system === "Sega Genesis") {
        file = cfg_obj["core_gen"];
    }
    else if (system === "Arcade") {
        file = cfg_obj["core_arcade"];
    }
    else if (system === "Film") {
        file = cfg_obj["core_film"];
    }
    else if (system === "Indie") {
        file = cfg_obj["core_indie"];
    }
    else {
        console.log("CORE WAS NOT ASSIGNED")
    }
    return file;
}

function coreOptions(core_data) {
        var result;
        switch(core_data) {
            case "320x240":
            case "auto":
            case "1500":
            case "dynamic_recompiler":
            case "low":
            case "BA":
            case "original":
            case "none":
                result = 0;
                break;
            case "fullspeed":
            case "2200":
            case "N64 3-point":
            case "640x360":
            case "hle":
            case "glide64":
            case "medium":
            case "memory":
            case "YA":
            case "cached_interpreter":
                result = 1;
                break;
            case "bilinear":
            case "640x480":
            case "cxd4":
            case "gln64":
            case "pure_interpreter":
            case "rumble":
            case "high":
            case "pure_interpreter":
                result = 2;
                break;
            case "nearest":
            case "720x576":
            case "rice":
                result = 3;
                break;
            case "800x600":
                result = 4;
                break;
            case "960x540":
                result = 5;
                break;
            case "960x640":
                result = 6;
                break;
            case "1024x576":
                result =7;
                break;
            case "1024x768":
                result = 8;
                break;
            case "1280x720":
                result = 9;
                break;
            case "1280x768":
                result = 10;
                break;
            case "1280x960":
                result = 11;
                break;
            case "1280x1024":
                result = 12;
                break;
            case "1600x1200":
                result = 13;
                break;
            case "1920x1080":
                result = 14;
                break;
            case "1920x1200":
                result = 15;
                break;
            case "1920x1600":
                result = 16;
                break;
            case "2048x1152":
                result = 17;
                break;
            case "2048x1536":
                result = 18;
                break;
            case "2048x2048":
                result = 19;
                break;
            default:
                result = 0;
                break
        }
        return result;
    }

function compareSystem(system, _nesModel, _snesModel, _psxModel, _n64Model,
                       _genesisModel, _gbModel, _gbaModel, _vbModel,
                       _arcadeModel, _filmModel, _indieModel, _pcModel) {
    var result = "";
    var index;
    switch(system) {
        case "Nintendo":
            index = parseInt(frontend_cfg["nes_index"])
            result = _nesModel.get(index).system;
            break;
        case "Super Nintendo":
            index = parseInt(frontend_cfg["snes_index"])
            result = _snesModel.get(index).system;
            break
        case "Nintendo 64":
            index = parseInt(frontend_cfg["n64_index"])
            result = n64Model.get(index).system;
            break
        case "Game Boy":
            index = parseInt(frontend_cfg["game_boy_index"])
            result = _gbModel.get(index).system;
            break
        case "Game Boy Color":
            index = parseInt(frontend_cfg["game_boy_index"])
            result = _gbModel.get(index).system;
            break
        case "Game Boy Advance":
            index = parseInt(frontend_cfg["game_boy_advance_index"])
            result = _gbaModel.get(index).system;
            break;
        case "Sony PlayStation":
            index = parseInt(frontend_cfg["psx_index"])
            result = _psxModel.get(index).system;
            break
        case "Arcade":
            index = parseInt(frontend_cfg["arcade_index"])
            result = _arcadeModel.get(index).system;
            break
        case "Virtual Boy":
            index = parseInt(frontend_cfg["vb_index"])
            result = _vbModel.get(index).system;
            break
        case "Computer":
            index = parseInt(frontend_cfg["pc_index"])
            result = _pcModel.get(index).system;
            break
        case "Sega Genesis":
            index = parseInt(frontend_cfg["genesis_index"])
            result = _genesisModel.get(index).system;
            break
        case "Film":
            index = parseInt(frontend_cfg["film_index"])
            result = _filmModel.get(index).system;
            break
        case "Indie":
            index = parseInt(frontend_cfg["indie_index"])
            result = _indieModel.get(index).system;
            break
        default:
            result = "System was not assigned"
            break;
    }
    return result;
}
