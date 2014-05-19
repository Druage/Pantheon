import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Rectangle {
    id: bottomToolbar
    property bool sliderPressed: slider.pressed;
    property real sliderVal: slider.value;
    property var sliderStyle: slider.style;
    property var textFieldStyle: searchBar.style;
    height: 40;
    width: parent.width;
    gradient:
        Gradient {
            GradientStop {position: 0.0; color: "#e24939";}
            GradientStop {position: 1.0; color: "#c13a2c";}
        }

     RowLayout {
        anchors.fill: parent;
        ToolButton {
            id: gridButton;
            Image {
                id: gridImage;
                anchors.centerIn: parent;
                source: "../../images/grid.png";
            }
            onClicked: {
                gridButton.state === "clicked" ? gridButton.state = "" : gridButton.state = "clicked"
                if (gridButton.state === "clicked") {
                    stackView.push(componentGrid);
                    leftColumnStackView.artworkSource = "";

                }
                else {
                    stackView.push(gameTable);
                }
            }
        }

        TextField {
            id: searchBar;
            implicitHeight: 25;
            implicitWidth: 300;
            anchors.centerIn: parent;
            anchors.verticalCenter: parent.verticalCenter;
            Keys.onReturnPressed: searchBar.state = "CLOSED";
            placeholderText: "Search...";

            Timer {
                id: timer;
                interval: 700;
                running: false;

                function filter(text) {
                    _libraryModel.query = "$[?(@.title.toLowerCase().indexOf('"
                                           + text.toLowerCase() +"') !== -1)]";
                }

                onTriggered: filter(searchBar.text);
            }

            onTextChanged: {
                if (text !== "") {
                    if (timer.running)
                        timer.restart();
                    else
                        timer.running = true;
                }
                else
                    _libraryModel.query = "$[*]";
            }
        }

        Slider {
            id: slider
            value: 25
            minimumValue: -50; maximumValue: 60
            implicitWidth: 100
            width: bottomToolbar.width / 6
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
