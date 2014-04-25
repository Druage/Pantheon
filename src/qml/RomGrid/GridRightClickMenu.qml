import QtQuick.Controls 1.1

Menu {
    id: rightClickMenu
    title: "Edit"
    MenuItem {
        text: "Add Artwork"
        onTriggered: artworkDialog.open()
    }
    MenuItem {
        text: "Remove Artwork"
        onTriggered: {
            gameView.model.get(gameView.currentIndex).image = "";
            oldModel.get(gameView.currentIndex).image = "";
        }
    }
}
