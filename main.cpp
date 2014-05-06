#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QQmlContext>
#include <QtQml/QQmlEngine>

#include <qqml.h>
#include "capturer.h"
#include "library.h"
#include "launch.h"
#include "cfg.h"
#include "shader.h"


int main(int argc, char *argv[]) {

    QApplication app(argc, argv);

    qmlRegisterType<Library>("Library", 1, 0, "Library");
    qmlRegisterType<Launch>("Launch", 1, 0, "Launch");
    qmlRegisterType<Config>("Config", 1, 0, "Config");
    qmlRegisterType<Shader>("Shader", 1, 0, "Shader");

    QQmlApplicationEngine engine(QUrl("src/qml/main.qml"));
    QObject *topLevel = engine.rootObjects().value(0);
    QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);

    window->show();
    return app.exec();
}
