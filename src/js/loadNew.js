/** The global component for save a centeral widget.*/
var centeralWidget = null;
 
/** Create a center widget with show data from MDL file.
*  @param qmlFile The full path to centeralWidget QML file.
*  @param parent The parent object on which centeral widget will be shown.
*  @author Andrew Shapovalov.*/
function createCenteralWidget(qmlFile, parent) {
    if (centeralWidget !== null) {
        centeralWidget.opacity = 0.0;
        centeralWidget.destroy();
    }

    var tmp = Qt.createComponent(qmlFile);
    var options = {
        "id": "widget",
        "anchors": {"top": parent.bottom},
        "width": parent.width,
        "height": parent.height};

    centeralWidget = tmp.createObject(parent, options);
     
    if (centeralWidget === null) {
        return false;
    }
     
    return true;
}

