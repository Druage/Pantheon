import QtQuick 2.1
import io.thp.pyotherside 1.0

Python {
    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('../py/'));
        importModule('xml_creator', function () {
            call('xml_creator.scan', ["/home/lee"])
            }
        )
    }
}
