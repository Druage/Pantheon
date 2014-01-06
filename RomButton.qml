import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.0

Rectangle {
    id: btn
    height: 30; width: 30
    radius: 8
    state: "ON"
    function toggle() { //makes the gridview switch
        if (state === "ON"){state = "OFF"; rom_grid.visible = true;
            innershadow.visible = true}
        else {state = "ON"; rom_grid.visible = false;
            innershadow.visible = false}
    }
    MouseArea {
        id: mousearea
        anchors.fill: parent
        onClicked: btn.toggle()
    }
    gradient: Gradient {
        GradientStop {position: 0.0; color: "#353535"}
        GradientStop {position: 1.0; color: "#232323"}
    }

    Image {
        id: btn_img
        anchors.centerIn: parent
        anchors.left: parent.left
        source: "images/grid_1.png"
        sourceSize.width: 20 ; sourceSize.height: 20
    }
    InnerShadow {
        id: innershadow
        visible: false
        anchors.fill: btn
        cached: true
        verticalOffset: 3
        horizontalOffset: -3
        radius: 8.0
        samples: 16
        color: "black"
        source: btn
    }
}

