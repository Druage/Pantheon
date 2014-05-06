#ifndef SHADER_H
#define SHADER_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QFile>

#include "qdebug.h"

class Shader : public QObject {
    Q_OBJECT

public:
    explicit Shader(QObject *parent = 0);

public slots:
    bool readCG(QString input_file);
    //bool readCGP(QString input_file);

    //bool writeCG();
    //bool writeCGP();

private:

};

#endif // SHADER_H
