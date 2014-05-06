#include "shader.h"

Shader::Shader(QObject *parent): QObject(parent) {
    cg_data["shaders"] = QString("1");
    cg_data["shader0"] = QString("null");
    cg_data["wrap_mode0"] = QString("clamp_to_border");
    cg_data["float_framebuffer0"] = QString("false");
}

bool Shader::writeCG(QString output_file) {
    cg_data["shader0"] = output_file;
    QFile outfile(output_file);
    if (!outfile.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate)) {
        qDebug() << "Error at Shader::writeCG: " << output_file << "was not found.";
        outfile.close();
        return false;
    }
    QStringList keys = cg_data.keys();
    QTextStream outstream(&outfile);
    for (int i=0; i < keys.length(); i++) {
        QString current_key = keys.at(i);
        QString value = cg_data[current_key];
        outstream << current_key << " = " << value << '\n';
    }
    qDebug() << "Saved cg file";
    outfile.close();
    return true;
}
