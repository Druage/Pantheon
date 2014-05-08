#include "shader.h"

//const, Qdir in shader.h, added readCG

const QString SHADERS_PATH = QDir::currentPath() + "/retroarch-v1.0.0.2/shaders/";
const QString RETROARCH_CGP = SHADERS_PATH + "retroarch.cgp";

Shader::Shader(QObject *parent): QObject(parent) {
    __cg_data["shaders"] = QString("1");
    __cg_data["shader0"] = QString("None");
    __cg_data["wrap_mode0"] = QString("clamp_to_border");
    __cg_data["float_framebuffer0"] = QString("false");
}

bool Shader::writeCG(QString shader_file) {
    shader_file = SHADERS_PATH + shader_file;
    __cg_data["shader0"] = shader_file;

    QFile outfile(RETROARCH_CGP);
    if (!outfile.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate)) {
        qDebug() << "Error at Shader::writeCG: " << shader_file << "was not found.";
        outfile.close();
        return false;
    }

    QStringList keys = __cg_data.keys();
    QTextStream outstream(&outfile);
    for (int i=0; i < keys.length(); i++) {
        QString current_key = keys.at(i);
        QString value = __cg_data[current_key];
        outstream << current_key << " = " << value << '\n';
    }
    qDebug() << "Saved shader file";
    outfile.close();
    return true;
}
