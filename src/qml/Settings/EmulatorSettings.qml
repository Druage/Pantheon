import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1

Rectangle {
    id: root;

    ToolButton {
        id: addTabButton;
        anchors.right: parent.right
        anchors.top: parent.top
        text: "+"
        onClicked: {
            if (tabView.count > 0) {
                tabView.insertTab(1, 'Blank', skeletonTab);
            }
            else {
                tabView.addTab('Blank', skeletonTab);
            }
        }
    }

    TabView {
        id: tabView
        anchors.top: addTabButton.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        Component.onCompleted: {
            insertTab(0, 'Blank', skeletonTab);
        }
    }

    Component {
        id: skeletonTab;
        ColumnLayout {
            RowLayout {
                height: 30
                anchors.left: parent.left
                anchors.right: parent.right
                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    id: nameLabel;
                    text: "Emulator Name:";
                }
                TextField {
                    anchors.right: parent.right
                    anchors.left: nameLabel.right
                    anchors.margins: 20
                    placeholderText: "Blank"
                    text: custom_emulators['title'];
                    onTextChanged: {
                        tabView.getTab(tabView.currentIndex).title = text
                        custom_emulators["title"] = text
                    }
                }
            }
            RowLayout {
                height: 30;
                anchors.left: parent.left;
                anchors.right: parent.right;
                Label {
                    text: "Emulator Path:";
                }
                TextField {
                    placeholderText: "/path/to/emulator.exe";
                    text: custom_emulators['executable'];
                }

                FileDialog {
                    id: emulatorDialog;
                    onAccepted: {
                        url = fileUrl.toString().replace('file:///', '');
                        custom_emulators["executable"] = url;
                    }
                }

                Button {
                    text: "Browse";
                }
            }
            RowLayout {
                height: 30;
                anchors.left: parent.left;
                anchors.right: parent.right;
                Label {
                    text: "Emulator Icon:";
                }
                Button {
                    text: "Add"
                    onClicked: iconDialog.open();
                }
                Image {
                    id: iconImage;
                    width: 50;
                    height: 50;
                    sourceSize.width: 50;
                    sourceSize.height: 50;
                    source: custom_emulators['system_icon'];
                    onSourceChanged: {
                        custom_emulators['system_icon'] = source;
                    }
                }

            FileDialog {
                    id: iconDialog;
                    title: "Select Emulator System Icon";
                    nameFilters: ["Executable Icon (*.png *.svg *.jpg *.bmp *.ico)", "All files (*)"];
                    onAccepted: {
                        var url = fileUrl.toString();
                        iconImage.source = url;
                    }
                }
            }
            RowLayout {
                height: 30
                anchors.left: parent.left
                anchors.right: parent.right
                Label {
                    text: "System Name:"
                }
                TextField {
                    placeholderText: "Nintendo 64"
                    text: custom_emulators["system"];
                    onTextChanged: {
                        custom_emulators["system"] = text;
                    }
                }
            }
            RowLayout {
                height: 30
                anchors.left: parent.left
                anchors.right: parent.right
                Label {
                    text: "System Arguments:"
                }
                TextField {
                    placeholderText: "-f,--no-log, (separate by a comma , )"
                    text: custom_emulators['arguments'];
                    onTextChanged: {
                        custom_emulators['arguements'] = text;
                    }
                }
            }
        }
    }
}
