import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Rectangle {
    id: root
    width: 400; height: 500
    color: "#272725"
    Rectangle {
        id: title
        height: 25; width: parent.width
        x: 15; y: 5
        color: "#000000FF"
        Label{anchors.verticalCenter: parent.verticalCenter; text: "Favorites";font.pixelSize: 12; color: "lightgray"}}
    ColumnLayout {
        spacing: 2
        anchors.top: title.bottom
        width: parent.width
        Component {
                id: highlightBar
                Rectangle {
                    width: root.width; height: 25
                    y: listview.currentItem.y;
                    gradient: Gradient {
                        GradientStop{position: 0.0; color: "#BB4F29"}
                        GradientStop{position: 1.0; color: "#B84F29"}
                    }
                    Behavior on y { SpringAnimation { spring: 3; damping: 0.1; mass: 0.1} }
                }
            }


        ListView {
            id: listview
            width: 200; height: 200
            visible: true
            focus: true
            highlightFollowsCurrentItem: false
            highlight: highlightBar
            model: FavoritesModel {}
            delegate: Item {
                id: wrapper
                width: root.width; height: 25
                x: 50
                states: State {
                    name: "Current"
                    when: wrapper.ListView.isCurrentItem
                    PropertyChanges { target: wrapper; x:  75 }
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered:  listview.currentIndex = index
                }
                RowLayout {
                    width: parent.width
                    spacing: 10
                    Label {id: label; text: name; font.pixelSize: 12; color: "lightgray"}
                }
            }
        }
    }
}










