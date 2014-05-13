# Add more folders to ship with the application, here
folder_01.source = src
folder_01.target = "."

DEPLOYMENTFOLDERS = folder_01
# Additional import path used to resolve QML modules in Creator's code model
#QML_IMPORT_PATH =

#DESTDIR = "."

# The .cpp file which was generated for your project. Feel free to hack it.
QT      += core widgets
SOURCES += "*.cpp"
RC_FILE = "icon.rc"
HEADERS += "library.h"  \
           "capturer.h" \
           "launch.h"   \
           "joystick.h" \
           "cfg.h"      \
           "shader.h"

#win32:INCLUDEPATH += "C:/Users/robert/Desktop/RetroarchPhoenix-master" \
                     #"C:\SDL2\include"
# Installation path
# target.path =
# unix:LIBS += -L/usr/lib/x86_64-linux-gnu/mesa/
# unix:LIBS += -L/usr/lib/x86_64-linux-gnu/qt5/io

#CONFIG(release, debug|release {message(Release)}
#CONFIG(debug, debug|release){message(Debug)}
# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    src/qml/StatusBubble/GameCounter.qml \
    src/qml/Settings/MednafenPSXSettings.qml
