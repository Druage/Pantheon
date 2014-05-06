#include "shader.h"

Shader::Shader(QObject *parent): QObject(parent) {}

bool Shader::readCG(QString input_file) {
    QFile infile(input_file);

    if (!infile.open(QIODevice::ReadOnly)) {
        qDebug() << "Error at Shader::readCG: " << input_file
                 << "was not found.";
        infile.close();
        return false;
    }

    QStringList string_list;
    QTextStream in(&infile);
    int count = 0;
    while (!in.atEnd()) {
        QString line = in.readLine();
        string_list.append(line);
        qDebug() << string_list[count];
        count++;
    }
    infile.close();
    return true;
}
