import QtQuick 2.0
import QtQuick.Controls 1.1
import QtGraphicalEffects 1.0

Rectangle {
    id: gameGrid
    width: 800
    height: 600
    color: "#D6DADE" //Grid Background Color
    visible: true
    z: -1
    GridView {
        id: gameView
        anchors.fill: parent
        anchors.margins: 20
        //columns: 5
        cellHeight: 250
        cellWidth: 190
        focus: true
        highlight: gameHighlighter
        model: LibraryModel {}
        delegate: gameDelegate

    Component {
        id: gameHighlighter
        Rectangle {
            color: "darkgray" //Highlighter Color
            height: 20; width: 20
            y: gameView.currentItem.y;
        }
    }
        Component {
            id: gameDelegate
            Rectangle {
                width: 125; height: 175 + gameLabel.contentHeight
                color: "#000000FF"
                id: gameFrame
                states: State {
                    name: "Current"
                    when: gameList.ListView.isCurrentItem
                    }
                MouseArea {
                    anchors.fill: parent
                    //hoverEnabled: true
                    onClicked: { gameView.currentIndex = index; console.log(gameView.model.get(gameView.currentIndex).path)}//console.log(gameList.model.get(gameList.currentItem).path) //Path is stored in DataModel
                    //onPressAndHold: gameView.destroy(gameView.currentIndex)
                }
                Rectangle {
                    id: gameRectangle
                    color: "#000000FF"
                    width: parent.width * 0.7; height: parent.height * 0.7
                    anchors.centerIn: parent
                    Image {
                        id: gameImage
                        source: "images/tv_color_bars.jpg"
                        anchors.centerIn: parent; //source: portrait
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        width: parent.width  ; height: parent.height
                        sourceSize.width: 500 ; sourceSize.height: 500
                    }
                }
                DropShadow{
                    cached: true
                    fast: false //May have to enable on slower systems
                    transparentBorder: true
                    anchors.fill: source
                    source: gameRectangle
                    radius: 8
                    samples: 16
                    color: "black"
                    verticalOffset: 3
                    horizontalOffset: 3
                }
                Label {
                    id: gameLabel
                    width: 170
                    anchors.topMargin: 10
                    anchors.top: gameRectangle.bottom;
                    //anchors.horizontalCenter: parent.horizontalCenter
                    text: title
                    font.pixelSize: 12
                    font.bold: true
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                }
            }
        }
    }//ListView
}//GridView

