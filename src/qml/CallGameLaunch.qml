import QtQuick 2.1
import io.thp.pyotherside 1.0

Python {
    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('../py/'));
        importModule('retroarch_launch', function () {
            call('retroarch_launch.launch', ["/home/lee"])
            }
        )
    }
}
