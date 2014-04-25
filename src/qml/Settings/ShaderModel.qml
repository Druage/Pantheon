import QtQuick.XmlListModel 2.0

XmlListModel {
    source: "../../database/shaders.xml"
    query: "/Shaders/file"
    XmlRole {name: "name";  query: "name/string()"}
    XmlRole {name: "path";  query: "path/string()"}
}
