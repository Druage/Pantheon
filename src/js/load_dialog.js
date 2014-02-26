function reloadComponent(load, comp) {
    if (load.sourceComponent === comp) {
        load.sourceComponent = Qt.createComponent("../qml/BlankComponent.qml")
    }
    load.sourceComponent = comp
}


