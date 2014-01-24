import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.1

//Not Implemented Yet

Rectangle {id: menu; height: 50; anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top
        color: "gray"
        clip: true
        RowLayout {
            anchors.fill: parent
            ToolButton {text: "System"; onClicked: {stackView.push([settings, stuff])}}

        }
    }
//	StackView {
        //anchors.fill: parent
    //}
