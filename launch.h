#ifndef LAUNCH_H
#define LAUNCH_H

#include <QObject>
#include <QProcess>
#include <qdebug.h>

class Launch : public QObject {
    Q_OBJECT
    
public:
    explicit Launch(QObject *parent = 0);
    
public slots:
    QString launch(QString);
    QString launch(QString, QString, QString, QString);

private:
    QProcess *m_process;
};

#endif // LAUNCH_H
