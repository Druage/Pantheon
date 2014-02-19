import QtQuick 2.0
import QtQuick.XmlListModel 2.0

XmlListModel {
    source: "../shaders.xml"
    query: "/Library/shader"
    XmlRole {name: "title";  query: "title/string()"}
    XmlRole {name: "path";  query: "path/string()"}
}
