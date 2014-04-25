import QtQuick 2.2

Rectangle {
    anchors.centerIn: gameView.currentItem;
    width: gameView.cellWidth;
    height: gameView.cellHeight;
    radius: 8;
    x: gameView.currentItem.x
    y: gameView.currentItem.y
    color: systemPalette.highlight
}
