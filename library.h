#ifndef LIBRARY_H
#define LIBRARY_H

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

#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>

#include <qdebug.h>

class Library : public QObject {
    Q_OBJECT
public:
    explicit Library(QObject *parent = 0);

public slots:
  int scanFolder(QString, QString);
  int scanRecursively(QString, QString);

  QString iteratorFilter(QString);

  bool deleteLibraryFile();

  friend void constructLibrary(QFileInfo file, QJsonArray &jsonArray, QJsonObject &jsonObject);
  friend int parseLibraryFile();
  friend void saveLibraryFile(QJsonObject obj);
  friend QString getConsole(QString);

signals:
  void gameCounter(int);
  void libraryChanged(QJsonObject);

};

#endif // LIBRARY_H
