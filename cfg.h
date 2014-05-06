#ifndef CFG_H
#define CFG_H

#include <QObject>
#include <QApplication>

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

#include <QFile>
#include <QTextStream>

#include "qdebug.h"

class Config : public QObject {
    Q_OBJECT

public:
    explicit Config(QObject *parent = 0);

public slots:
    QJsonObject readDefaultFrontEndConfigFile();
    QJsonObject readDefaultRetroArchConfigFile();
    QJsonObject readConfigFile(QString input_file);
    bool saveFrontendConfig(QJsonObject config_file);
    bool saveConfig(QString output_file, QJsonObject config_file);

private:

signals:

};

#endif // CFG_H
