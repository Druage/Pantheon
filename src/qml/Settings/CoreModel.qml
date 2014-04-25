import QtQuick.XmlListModel 2.0

XmlListModel {
    source: "../../database/cores.xml"
    query: "/Cores/file"
    XmlRole {name: "NES";  query: "NES/string()"}
    XmlRole {name: "SNES";  query: "SNES/string()"}
    XmlRole {name: "GB";  query: "GB/string()"}
    XmlRole {name: "GBA";  query: "GBA/string()"}
    XmlRole {name: "GENESIS";  query: "GENESIS/string()"}
    XmlRole {name: "ARCADE";  query: "ARCADE/string()"}
    XmlRole {name: "PSX";  query: "PSX/string()"}
    XmlRole {name: "N64";  query: "N64/string()"}
    XmlRole {name: "INDIE";  query: "INDIE/string()"}
    XmlRole {name: "FILM";  query: "FILM/string()"}
    XmlRole {name: "PC";  query: "PC/string()"}
}
