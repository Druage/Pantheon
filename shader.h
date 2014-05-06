#ifndef SHADER_H
#define SHADER_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QMap>
#include <QFile>
#include <QTextStream>
#include <QDir>

#include "qdebug.h"

class Shader : public QObject {
    Q_OBJECT

public:
    explicit Shader(QObject *parent = 0);

public slots:
    bool writeCG(QString shader_file);
    //bool writeCGP();

private:
    QMap<QString, QString> __cg_data;
};

#endif // SHADER_H
