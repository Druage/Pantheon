import QtQuick 2.0

Rectangle {
    height: 20
    width: 120
    Rectangle {
        id: btn
        width: parent.width; height: 0
        states: [
            State {
                name: "hovered"
                PropertyChanges {target: btn; height: 30}
            }
        ]
        gradient: Gradient {
            GradientStop {position: 0.0; color: "#E0BF4F"}
            GradientStop {position: 1.0; color: "#C19D22"}
        }

        Button {anchors.horizontalCenter: parent.horizontalCenter;
            anchors.centerIn: parent; height: 20; width: 20
            MouseArea {
                anchors.fill: parent
                onClicked: {topMenu.state == "clicked" ? topMenu.state = "" : topMenu.state = "clicked";}
                }
            }
    }
    Rectangle {
        id: topMenu
        anchors.top: btn.bottom
        width: parent.width
        height: 0
        color: "#D7AE26"
        states: [
            State {
                name: "clicked"
                PropertyChanges {target: topMenu; height: 100}
                PropertyChanges {target: rowMenu; enabled: true}
            }
        ]
        transitions: Transition {
            PropertyAnimation {property: "height"; easing.type: Easing.OutQuad}
        }
        RowLayout {
            id: rowMenu
            anchors.fill: parent
            enabled: false
            ToolButton {text: "Advanced Settings"; onClicked: stackView.push(advancedSettings)}
            ToolButton {text: "Cores"; onClicked: stackView.push(cores)}
            ToolButton {text: "TableView"; onClicked: stackView.push(gameTable)}
            ToolButton {text: "Grid Games"; onClicked: stackView.push(gameGrid)}
            ToolButton {text: "Library Paths"; onClicked: stackView.push(libraryPaths)}
        }
    }
}
