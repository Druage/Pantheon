import QtQuick 2.1
import io.thp.pyotherside 1.0

Python {
    id: py
    signal open(string first)
    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('../py'));
        setHandler('append', open)

        importModule('retroarch_download', function() {
        console.log("should be imported")
        })
    }
    onReceived: console.log('Unhandled event: ' + data)
    onOpen: console.log(first)
}
