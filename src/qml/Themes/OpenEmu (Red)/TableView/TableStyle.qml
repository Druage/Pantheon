import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

TableViewStyle {
    highlightedTextColor: "white"
    alternateBackgroundColor: "#000000"
    backgroundColor: "#1d1d1d"

    property string fontColor: "white"
    property var highlightGradient: Gradient {
        GradientStop {position: 0.0; color: "#cc4d4d";}
        GradientStop{position: 0.5; color: "#ad4141";}
        GradientStop {position: 1.0; color: "#933b3b";}
    }


    headerDelegate:
        Rectangle {
            anchors.fill: parent
            height: 25;
            gradient: Gradient {
                GradientStop {position: 0.0; color: "#4a4a4a"}
                GradientStop {position: 1.0; color: "#2b2b2b"}
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: styleData.value
                color: fontColor
            }
        }

    itemDelegate:
        Label  {
            x: 12
            width: Text.contentWidth
            //anchors.verticalCenter: parent.verticalCenter
            text: styleData.value
            color: fontColor
            elide: Text.ElideRight
        }



    scrollBarBackground:
        Rectangle {
            height: 0
            opacity: 0.2
            //height: 10
            //color: "yellow"
        }
    corner:
        Rectangle {
        height: 20
        width: 10
            color: "red"
        }

    frame:
        Rectangle {
            width: 1.0
            color: "#000000"
        }
    }
