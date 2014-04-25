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
    Rectangle {
        id: rectBorder;
        color: "#000000";
        anchors.top: parent.top;
        height: 1;
        width: parent.width;
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
            function filter() {
                for (var i=0; i < libraryModel.count; i++) {
                    var x = libraryModel.get(i)
                    if (!x.title.toLowerCase().indexOf(text.toLowerCase())) {
                        newLibraryModel.append(x);
                        libraryModel = newLibraryModel;
                        break;
                    }
                }
            }
            onAccepted: {
                newLibraryModel.clear();
                libraryModel = oldModel;
                if (text !== "") {
                    filter();
                }
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
