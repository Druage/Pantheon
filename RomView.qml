import QtQuick 2.0
import QtQuick.Controls 1.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.0

//make these images appear automatic with Repeater {}

Rectangle {
    width: 100
    height: 250
    color: "gray"
    NoisyGradient {
        width: parent.width; height: parent.height
    }

    /*gradient: Gradient {
        GradientStop {position: 0.0; color: "#323232"}
        GradientStop {position: 1.0; color: "#272727"}
    }*/
    ScrollView {
        width: parent.width; height: parent.height
        GridView {
            id: game_grid
            anchors.fill: parent
            anchors.margins:10
            cellHeight: 100
            cellWidth: 100
            //highlight: highlight
            model: ModelGame {}
            delegate: gameDelegate
            MouseArea {
                anchors.fill: parent
                onClicked: destroy()
            }
      ListView {
          id: gameview
          width: 200; height: 250
          model: ModelGame {}
        Component {
            id: gameDelegate
            Column {
                Rectangle {
                    width: gameview.height; height: gameview.width
                    color: "red"
                    id: rect
                    visible: true
                    DropShadow {
                        anchors.fill: parent
                        cached: true
                        verticalOffset: 5
                        horizontalOffset: 5
                        radius: 8
                        samples: 16
                        color: Qt.rgba(0,0,0, .2 )
                        source: parent
                    }
                    Image {
                        anchors.centerIn: parent; source: portrait
                        //fillMode: Image.PreserveAspectCrop
                        //smooth: true
                        width: parent.width-10 ; height: parent.height-10
                        sourceSize.width: 500 ; sourceSize.height: 500
                    }
                }
                Item {
                    anchors.top: rect.bottom
                    anchors.topMargin: 5
                    x: 14
                   /* ListView {
                        model: ModelGame {}
                        delegate: Text {text: name; color: "white"}
                    }*/
                        }
                    }
                }
            }
        }
    }
}
