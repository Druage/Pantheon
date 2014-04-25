#include <scanner.h>

Scanner::Scanner(QObject *parent): QObject(parent) {
}

QString Scanner::getConsole(QString ext) {
    QString console;
    if (ext == "nes" ||
        ext == "fds" ||
        ext == "unif") {
        console = "Nintendo";
    }
    else if (ext == "n64" ||
             ext == "v64" ||
             ext == "z64") {
        console = "Nintendo 64";
    }
    else if (ext == "sfc" ||
             ext == "smc" ||
             ext == "fig" ||
             ext == "gd3" ||
             ext == "gd7" ||
             ext == "dx2" ||
             ext == "bsx" ||
             ext == "swc") {
        console = "Super Nintendo";
    }
    else if (ext == "gb") {
        console = "Game Boy";
    }
    else if (ext == "gbc") {
        console = "Game Boy Color";
    }
    else if (ext == "cue") {
        console = "Sony PlayStation";
    }
    else if (ext == "vb") {
        console = "Virtual Boy";
    }
    else if (ext == "gba") {
        console = "Game Boy Advance";
    }
    else if (ext == "gen") {
        console = "Genesis";
    }
    else if (ext == "nds") {
        console = "Nintendo DS";
    }
    else if (ext == "gcz") {
        console = "Game Cube";
    }
    else if (ext == "wad" ||
             ext == "wbfs") {
        console = "Wii";
    }
    else if (ext == "zip" ||
             ext == "7z") {
        console = "Archive";
    }
    else {
        console = "Unknown";
    }
    return console;
}

QString Scanner::iteratorFilter(QString extension) {
    return Scanner::getConsole(extension);
}

void Scanner::constructJson(QFileInfo file, QJsonArray &jsonArray, QJsonObject &jsonObject) {
    jsonObject["title"] = file.completeBaseName();
    jsonObject["path"] = file.absoluteFilePath();
    jsonObject["extension"] = file.suffix();
    jsonObject["console"] = Scanner::getConsole(file.suffix().toLower());
    jsonObject["valid"] = QString("");
    jsonObject["image"] = QString("file:///" + QApplication::applicationDirPath() +
                                  "/src/images/missing_artwork.png");
    jsonObject["description"] = QString("");
    jsonObject["genre"] = QString("");
    jsonObject["players"] = QString("");
    jsonObject["publisher"] = QString("");
    jsonObject["XML"] = QString("");
    jsonArray.append(jsonObject);
}

int Scanner::scanFolder(QString directory, QString outputPath) {
    QDir dir(directory);
    if (dir.exists()) {
        qDebug() << "Directory Exists.";
        dir.setFilter(QDir::Dirs | QDir::NoDotAndDotDot);
        dir.setFilter(QDir::Files);

        QStringList filter;
        filter << "*.n64"  << "*.v64" << ".z64" << "*.nes" << "*.sfc" << "*.smc" << "*.zip"
               << "*.7z";

        dir.setNameFilters(filter);

        QJsonArray topArray;
        QJsonObject jsonObject;

        foreach(QFileInfo file, dir.entryList(filter)) {
            constructJson(file, topArray, jsonObject);
        }
        QFile outFile("src/database/" + outputPath);
        outFile.open(QIODevice::WriteOnly | QIODevice::Text| QFile::Truncate);

        QJsonDocument document(topArray);
        outFile.write(document.toJson());
        outFile.close();
        return 1;
    }
    else {
        qDebug() << directory << " does not exist.";
        return 0;
    }
}

int Scanner::scanRecursively(QString directory, QString outputPath) {
    QDir dir(directory);
    if (dir.exists()) {
        QJsonArray topArray;
        QJsonObject jsonObject;

        QDirIterator iterator(dir.absolutePath(), QDirIterator::Subdirectories);
        while (iterator.hasNext()) {
            iterator.next();
            if (!iterator.fileInfo().isDir()) {
                if (iteratorFilter(iterator.fileInfo().suffix()) != "Unknown")
                    constructJson(iterator.fileInfo(), topArray, jsonObject);
            }
        }
        QFile outFile("src/database/" + outputPath);
        outFile.open(QIODevice::WriteOnly | QIODevice::Text| QFile::Truncate);

        QJsonDocument document(topArray);
        outFile.write(document.toJson());
        outFile.close();
        qDebug() << "Library created";
        return 1;
    }
    else {
        qDebug() << directory << " does not exist.";
        return 0;
    }
}
