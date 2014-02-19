# Add more folders to ship with the application, here
folder_01.source = src
folder_01.target = "."
DEPLOYMENTFOLDERS = folder_01
# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# The .cpp file which was generated for your project. Feel free to hack it.
QT      += core widgets
SOURCES += "*.cpp"
# Installation path
# target.path =
unix:LIBS += -L/usr/lib/x86_64-linux-gnu/mesa/
unix:LIBS += -L/usr/lib/x86_64-linux-gnu/qt5/io


CONFIG(release, debug|release)
{
    message(Release)
}

CONFIG(debug, debug|release)
{
    message(Debug)
}
# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()
