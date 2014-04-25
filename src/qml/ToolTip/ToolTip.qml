import QtQuick 2.2

Rectangle {
    id: tooltip
    width: parent.width - 20
    height: tooltipText.height + 10

    property int fadeInDelay
    property int fadeOutDelay
    property alias text: tooltipText.text

    color: "black"
    radius: 6
    anchors.centerIn: parent
    state: ""

    // The object travels from an empty state(on creation) to 'poppedUp' state and then to 'poppedDown' state
    states: [
        State {
            name: "poppedUp"
            PropertyChanges { target: tooltip; opacity: 1 }
        },

        State {
            name: "poppedDown"
            PropertyChanges { target: tooltip; opacity: 0 }
        }
    ]

    transitions: [
        Transition {
            from: ""
            to: "poppedUp"
            PropertyAnimation { target: tooltip; property: "opacity"; duration: tooltip.fadeInDelay; }
        },

        Transition {
            from: "poppedUp"
            to: "poppedDown"
            PropertyAnimation { target: tooltip; property: "opacity"; duration: tooltip.fadeOutDelay; }
        }
    ]


    Text {
        id: tooltipText
        font.bold: true
        font.pixelSize: 16
        color: "white"
        anchors.centerIn: parent
    }

    onStateChanged: {
        if (tooltip.state == "poppedDown") {
            console.debug("Destroyed!");
            tooltip.destroy(tooltip.fadeOutDelay);
            // If you think that the above line is ugly then, you can destroy the element in onOpacityChanged: if (opacity == 0)
        }
    }
}
