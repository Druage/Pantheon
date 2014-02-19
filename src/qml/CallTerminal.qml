import QtQuick 2.1
import io.thp.pyotherside 1.0

Python {
    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('../py/'));
        importModule('call_joyconfig', function () {
            call('call_joyconfig.call', [], function (result) {
                console.log("result: " + result)
            })
            }
        )
    }
}
