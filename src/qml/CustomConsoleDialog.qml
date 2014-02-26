import QtQuick 2.1
import QtQuick.Controls 1.1
import io.thp.pyotherside 1.0
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0


ApplicationWindow{
    id: root
    title: "Add Custom Core"
    height: 250
    width: 350
    visible: true
    //flags: Qt.Dialog
    minimumHeight: root.height
    minimumWidth: root.width
    maximumHeight: root.height
    maximumWidth: root.width
    Python {
        id: py
        signal accept(string result)
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../py'));
            importModule('storage', function () {})
        }
        onAccept: {
            console.log()
        }
    }
    TabView {
        id: tabView
        anchors.fill: parent
        Component.onCompleted: {
            addTab("Skeleton", newCore1)
        }
    }

        Component {
            id: newCore1
            ColumnLayout {
                id: colLayout
                anchors.fill: parent
                TextField {
                    id: exeField
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 10
                    height: 30
                    placeholderText: "Executable... dolphin.exe"
                }
                TextField {
                    id: argsField
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 10
                    height: 30
                    placeholderText: "Emulator Arguments... -f, --no-log"
                }
                TextField {
                    id: extensField
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 10
                    height: 30
                    placeholderText: "Game extension... *.zip, *.smc, *.gcz"
                }
                RowLayout {
                    id: bottomRow
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 30
                    Button {
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        text: "Save"
                        onClicked: py.call('storage.write',
                                           [[exeField.text, argsField.text,
                                             extensField.text]],
                                           function (result) {console.log(result)})
                    }
                    Button {
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        text: "Cancel"
                        onClicked: root.close()
                    }
                }
            }
        }
}
