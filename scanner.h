#ifndef SCANNER_H
#define SCANNER_H

#include <QObject>
#include <QCoreApplication>
#include <QApplication>

#include <QString>
#include <QByteArray>

#include <QDir>
#include <QDirIterator>
#include <QFile>
#include <QIODevice>
#include <QTextStream>
#include <QUrl>

#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>

#include <scanner.h>
#include <qdebug.h>

class Scanner : public QObject {
    Q_OBJECT
public:
    explicit Scanner(QObject *parent = 0);
    Q_INVOKABLE int scanFolder(QString, QString);
    Q_INVOKABLE int scanRecursively(QString, QString);
    Q_INVOKABLE void constructJson(QFileInfo file, QJsonArray &jsonArray, QJsonObject &jsonObject);
    Q_INVOKABLE QString iteratorFilter(QString);
    Q_INVOKABLE QString getConsole(QString);

signals:

public slots:

};

#endif // SCANNER_H
