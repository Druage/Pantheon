import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.0

Rectangle {
    id: btn
    height: 30; width: 30
    radius: 8
    MouseArea {
        id: mousearea
        anchors.fill: parent
        onPressed: file_dialog.open()
        //onReleased: innershadow.visible = false
    }
    gradient: Gradient {
        GradientStop {position: 0.0; color: "#353535"}
        GradientStop {position: 1.0; color: "#232323"}
    }

    Image {
        id: btn_img
        anchors.centerIn: parent
        anchors.left: parent.left
        source: "images/plus.png"
        sourceSize.width: 500 ; sourceSize.height: 500
    }
    InnerShadow {
        id: innershadow
        anchors.fill: btn
        cached: true
        verticalOffset: 3
        horizontalOffset: -3
        radius: 8.0
        samples: 16
        color: "black"
        source: btn
    }
    FileDialog {
        id: file_dialog
        title: "Choose a Game File"
        visible: false
        onAccepted: {
            console.log("You choose: " + file_dialog.fileUrls)
            Qt.quit()
        }
        onRejected: {
            console.log("Cancelled")
            close()
        }
    }
}

