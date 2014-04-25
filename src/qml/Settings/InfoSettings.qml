import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.XmlListModel 2.0

TableView {
    id: root
   // property var defaultStyle
    //style: defaultStyle
    model: XmlListModel {
        id: xmlModel
        source: "../../database/libretro_database.xml"
        query: "/Database/core"

        XmlRole {name: "display_name";  query: "display_name/string()"}
        XmlRole {name: "authors";  query: "authors/string()"}
        XmlRole {name: "supported_extensions";  query: "supported_extensions/string()"}
        XmlRole {name: "corename";  query: "corename/string()"}
        XmlRole {name: "manufacturer";  query: "manufacturer/string()"}
        XmlRole {name: "systemname";  query: "systemname/string()"}
        XmlRole {name: "license";  query: "license/string()"}
        XmlRole {name: "permissions";  query: "permissions/string()"}
        XmlRole {name: "firmware_count";  query: "firmware_count/string()"}
    }

    TableViewColumn {
        width: 25;
        /*delegate: Label {
            text: "hello"
        }*/
    }

    //TableViewColumn {role: "display_name"; title: "Name"}
    TableViewColumn {role: "corename"; title: "Core"; width: 200}
    TableViewColumn {role: "authors"; title: "Authors"; width: 225}
    TableViewColumn {role: "systemname"; title: "System"; width: 300}
    TableViewColumn {role: "supported_extensions"; title: "Extension"; width: 450}
    TableViewColumn {role: "manufacturer"; title: "Manufacturer"; width: 105}
    TableViewColumn {role: "license"; title: "License"; width: 150}
    //TableViewColumn {role: "permissions"; title: "Permissions"; width: 100}
    //TableViewColumn {role: "firmware_count"; title: "Firmware"; width: 100}
}
