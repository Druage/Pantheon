import QtQuick 2.1

Item {
    property var model
    anchors.fill: parent
    height: content.height; width: content.width
    Loader {
        id: content
        sourceComponent: treeBranch
        property var elements: model
        property bool isRoot: true

        Component {
            id: treeBranch
            Item {
                id: root
                implicitHeight: column.implicitHeight
                implicitWidth: column.implicitWidth + 4
                Column {
                    id: column
                    x: 2
                    spacing: 2
                    Text { text: !!root.isRoot ? "" : " " }
                    Repeater {
                        model: elements
                        Row {
                            spacing: 2
                            Rectangle {
                                width: 18
                                height: 18
                                color: "#000000FF" //makes it transparent
                                //opacity: !!model.elements ? 1 : 0
                                Image {
                                    id: expander
                                    source: "images/bookmark.png"
                                    opacity: mouse.containsMouse ? 1 : 0.7
                                    anchors.centerIn: parent
                                    //rotation: loader.expanded ? 90 : 0
                                    //Behavior on rotation {NumberAnimation { duration: 120}}
                                }
                                MouseArea {
                                    id: mouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: loader.expanded = !loader.expanded
                                    // possibly use this for buttons
                                }
                            }
                            Text { text: model.text; color: "white"}
                            Loader {
                                id: loader
                                height: 15
                                property bool expanded: false
                                property var elements: model.elements
                                property var text: model.text
                                sourceComponent: (expanded && !!model.elements) ? treeBranch : undefined
                            }
                        }
                    }
                }
            }
        }
    }
}
