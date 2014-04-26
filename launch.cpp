#include "launch.h"

Launch::Launch(QObject *parent) :
    QObject(parent), 
    m_process(new QProcess(this)) {
}

QString Launch::launch(QString executable) {
    QString program = QString("%1").arg(executable);
    m_process->start(program);
    m_process->waitForFinished(-1);
    QByteArray bytes = m_process->readAllStandardOutput();
    QString output = QString::fromLocal8Bit(bytes);
    return output;
}

QString Launch::launch(QString executable, QString config, QString core, QString game) {
    qDebug() << executable;
    QString program = QString("%1 -c %2 -L %3 %4").arg(executable, config, core, game);
    qDebug() << "launching:: " << program;
    m_process->start(program);
    m_process->waitForFinished(-1);
    QByteArray bytes = m_process->readAllStandardOutput();
    QString output = QString::fromLocal8Bit(bytes);
    return output;
}
