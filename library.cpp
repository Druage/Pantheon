#include <library.h>

const QString LIBRARY_NAME = "library.json";
const QString LIBRARY_FILE = QDir::currentPath() + "/src/qml/JSONListModel/" + LIBRARY_NAME;

Library::Library(QObject *parent): QObject(parent) {}


QString getConsole(QString ext) {
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

void constructLibrary(QFileInfo file, QJsonArray &jsonArray, QJsonObject &jsonObject) {
    jsonObject["title"] = file.completeBaseName();
    jsonObject["path"] = file.absoluteFilePath();
    jsonObject["extension"] = file.suffix();
    jsonObject["console"] = getConsole(file.suffix().toLower());
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

int parseLibraryFile() {
    QString val;
    QFile file;
    file.setFileName(LIBRARY_NAME);
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    if (file.isOpen()) {
        val = file.readAll();
        file.close();

        qWarning() << val;
        qDebug() << "library is open";
        QJsonDocument document = QJsonDocument::fromJson(val.toUtf8());
        QJsonObject obj = document.object();
        //emit libraryChanged(obj);
        return 1;
    }
    else {
        qDebug() << LIBRARY_NAME << " does not exist";
        return 0;
    }
}

bool Library::deleteLibraryFile() {
    return QFile::remove(LIBRARY_FILE);
}

QString Library::iteratorFilter(QString extension) {
    return getConsole(extension);
}

int Library::scanFolder(QString directory, QString outputPath) {
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
            constructLibrary(file, topArray, jsonObject);
        }
        QFile outFile("src/qml/JSONListModel/" + outputPath);
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

int Library::scanRecursively(QString directory, QString outputPath) {
    QDir dir(directory);
    //int counter = 0;
    if (dir.exists()) {
        QJsonArray topArray;
        QJsonObject jsonObject;

        QDirIterator iterator(dir.absolutePath(), QDirIterator::Subdirectories);
        // QVector <QDirIterator> filesVect;
        while (iterator.hasNext()) {
            iterator.next();
            if (!iterator.fileInfo().isDir()) {
                if (iteratorFilter(iterator.fileInfo().suffix()) != "Unknown") {
                    //counter++;
                    //filesVect.append(iterator);
                    constructLibrary(iterator.fileInfo(), topArray, jsonObject);
                }
            }
        }


        //for (int i=0; i < filesVect.count(); i++) {
        //    QDir info = filesVect[i].fileInfo();
        //    qDebug() << info.absoluteFilePath();
        //}


        //qDebug() << counter;
        QFile outFile("src/qml/JSONListModel/" + outputPath);
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

QJsonObject Library::getPaths(QString retroarch_path) {
    QDir retroarch(retroarch_path);
    retroarch.setFilter(QDir::Dirs | QDir::NoDotAndDotDot);
    QJsonObject folders;
    QDirIterator iterator(retroarch.absolutePath(), QDirIterator::Subdirectories);
    while (iterator.hasNext()) {
        iterator.next();
        if (iterator.fileInfo().isDir()) {
            QString folder_name = iterator.fileName();
            if (folder_name == "autoconfig"
                || folder_name == "configs"
                || folder_name == "cores"
                || folder_name == "libretro"
                || folder_name == "shaders"
                || folder_name == "system") {

                qDebug() << iterator.filePath();
                folders[folder_name] = iterator.filePath();
            }
        }
    }
    qDebug() << folders.length();
    return folders;
}
