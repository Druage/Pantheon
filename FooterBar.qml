import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
import QtGraphicalEffects 1.0

Rectangle {
    id: footerbar
    //implicitHeight: 75
    //width: 500
    border.width: 2
    border.color: "#505050"
    InnerShadow {
        anchors.fill: parent
        //visible: false
        cached: true
        verticalOffset: -1
        horizontalOffset: 1
        radius: 10
        samples: 16
        color: "black"
        source: footerbar
    }
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#333333"}
        GradientStop { position: 1.0; color: "#262626"}
    }
    RowLayout {
        anchors.fill: parent
        PlusButton {
            id: plus_btn
            anchors.left: parent.left
            anchors.leftMargin: 20
        }
        PlayButton {
            id: play_btn
            anchors.left: plus_btn.right
            anchors.leftMargin: 2
        }
        GridButton {
            id: grid_btn //You can edit the values so I can use just two btns
            anchors.right:search_bar.left
            //anchors.left: play_btn.right
            anchors.rightMargin: 2
        }

        TextField {
            id: search_bar
            placeholderText: "Search..."
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            style: TextFieldStyle {
                placeholderTextColor: "white"
                textColor: "white"
                background: Rectangle {
                    radius: 10
                    //border.width: control.activeFocus ? 2 : 1
                    //border.color: "#1c9099"
                    implicitHeight:30
                    implicitWidth: root.width / 3
                    gradient: Gradient {
                        GradientStop {position: 0.0; color: "#353535"}
                        GradientStop {position: 1.0; color: "#232323"}
                    }
                    InnerShadow {
                        id: search_bar_shadow
                        anchors.fill: parent
                        visible: true
                        cached: true
                        verticalOffset: 3
                        horizontalOffset: -3
                        radius: 8.0
                        samples: 16
                        color: "black"
                        source: search_bar
                    }
                }
            }
        }
        Slider {
            id: slider
            anchors.leftMargin: root.width / 6
            anchors.rightMargin: 10
            anchors.left: search_bar.right
            anchors.right: root.right
            minimumValue: 1; maximumValue: 10

            style: SliderStyle {
                groove: Rectangle {
                    id: groove
                    implicitWidth: root.width / 8
                    implicitHeight: 8
                    radius: 8
                    color: "#3690c0" // too small for useful gradient
                    InnerShadow {
                        anchors.fill: groove
                        //visible: false
                        cached: true
                        verticalOffset: 2
                        horizontalOffset: -2
                        radius: 10
                        samples: 16
                        color: "black"
                        source: groove
                    }
                }
               handle: Rectangle{
                   id: handle
                   height: 17
                   width: 17
                   radius: 10
                   //Shadow is glitching out, will use later.
                   /*DropShadow {
                       anchors.fill: handle
                       //visible: false
                       cached: true
                       verticalOffset: 1
                       horizontalOffset: -1
                       radius: 1
                       samples: 8
                       color: "black"
                       source: handle
                   }*/
               }
            }
        }
    }
}

