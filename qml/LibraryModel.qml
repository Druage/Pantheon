import QtQuick 2.0
import QtQuick.XmlListModel 2.0

XmlListModel {
    id: libraryModel
    source: "../games.xml"
    query: "/Library/game"
    XmlRole {name: "title";  query: "title/string()"}
    XmlRole {name: "path";  query: "path/string()"}
    XmlRole {name: "system"; query: "system/string()"}
	XmlRole {name: "core"; query: "core/string()"}
	XmlRole {name: "core_path"; query: "core_path/string()"}
}
