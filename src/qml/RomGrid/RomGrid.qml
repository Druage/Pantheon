import QtQuick 2.2

GridView {
    id: gameView;
    property bool sliderChanging: bottomToolbar.sliderPressed;
    anchors {
        fill: parent;
        topMargin: 70;
        leftMargin: 60;
        rightMargin: 20;
        bottomMargin: 40;
        centerIn: parent;
    }

    focus: true;
    model: libraryModel;
    delegate: Delegate {id: gridDelegate;}
    highlight: Highlighter {id: gridHighlighter;}
    highlightFollowsCurrentItem: false;
    keyNavigationWraps: true;
    cellHeight: 300 + bottomToolbar.sliderVal / 2;
    cellWidth: 350 + bottomToolbar.sliderVal / 2;
    Keys.onPressed: {
        if (event.key === Qt.Key_Tab) {
            if (flipCount == 0) {
                flipCount = 1;
                gridView.currentItem.flipped = true;
            }
            else {
                flipCount = 0;
                gridView.currentItem.flipped = false;
            }
        }
    }
}
