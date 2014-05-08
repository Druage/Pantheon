#include "cfg.h"

// Declare Globals

// Initialize Class
Config::Config(QObject *parent): QObject(parent) {}

// Define Methods
QJsonObject Config::readDefaultFrontEndConfigFile() {
    QString input_file = QApplication::applicationDirPath()
                         + "/src/database/frontend.cfg";
    return readConfigFile(input_file);
}

QJsonObject Config::readDefaultRetroArchConfigFile() {
    QString input_file = QApplication::applicationDirPath()
                         + "/src/database/win32_retroarch.cfg";
    return readConfigFile(input_file);
}

QJsonObject Config::readConfigFile(QString input_file) {
    QFile infile(input_file);
    QJsonObject json_object;

    if (!infile.open(QIODevice::ReadOnly)) {
        qDebug() << "Error at Config::readConfigFile: " << input_file << "was not found.";
        return json_object;
    }

    QTextStream in(&infile);
    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList fields = line.split(" = ");
        json_object[fields[0]] = fields[1];
    }
    infile.close();
    return json_object;
}

bool Config::saveFrontendConfig(QJsonObject json_object) {
    QString output_file = QApplication::applicationDirPath() + "/src/database/frontend.cfg";
    QFile outfile(output_file);

    if (!outfile.open(QIODevice::WriteOnly
                      | QIODevice::Text
                      | QFile::Truncate)) {
        qDebug() << "Error: " << "with opening frontend.cfg to write.";
        return false;
    }

    QStringList keys = json_object.keys();
    if (keys.length()) {
        QTextStream out(&outfile);
        for (int i=0; i < keys.length(); i++) {
            QString current_key = keys.at(i);
            QString value = json_object[current_key].toString();
            out << current_key << " = " << value << '\n';
        }
        qDebug() << "Wrote frontend.cfg";
        outfile.close();
        return true;
    }
    qDebug() << "Error: Config File is empty.";
    outfile.close();
    return false;
}

bool Config::saveConfig(QString output_file, QJsonObject json_object) {
    QFile outfile(output_file);

    if (!outfile.open(QIODevice::WriteOnly
                      | QIODevice::Text
                      | QFile::Truncate)) {
        qDebug() << "Error: with opening " << output_file << " to write.";
        return false;
    }

    QStringList keys = json_object.keys();
    if (keys.length()) {
        QTextStream out(&outfile);
        for (int i=0; i < keys.length(); i++) {
            QString current_key = keys.at(i);
            QString value = json_object[current_key].toString();
            out << current_key << " = " << value << '\n';
        }
        qDebug() << "Wrote config file.";
        outfile.close();
        return true;
    }
    qDebug() << "Error: config file is empty.";
    outfile.close();
    return false;
}
