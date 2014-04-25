#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QQmlContext>
#include <QtQml/QQmlEngine>
#include <qqml.h>

#include <capturer.h>
#include <scanner.h>


int main(int argc, char *argv[]) {

    QApplication app(argc, argv);

    qmlRegisterType<Scanner>("Scanner", 1, 0, "Scanner");

    QQmlApplicationEngine engine(QUrl("src/qml/main.qml"));
    QObject *topLevel = engine.rootObjects().value(0);
    QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);

    window->show();
    return app.exec();
}
