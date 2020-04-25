#include "plasmai3workspaces.h"
#include <QDebug>

PlasmaI3Workspaces::PlasmaI3Workspaces(QObject *parent) : QObject(parent) {}

QString PlasmaI3Workspaces::getWorkspaces() {
    QProcess i3_process;
    QString i3_bin = "i3-msg";
    QStringList i3_args;
    i3_args << "-t" << "get_workspaces";
    i3_process.start(i3_bin, i3_args);

    i3_process.waitForFinished();

    return QString(i3_process.readAllStandardOutput());
}

void PlasmaI3Workspaces::goToWorkspace(QString ws) {
    QString i3_bin = "i3";
    QStringList i3_args;
    // i3_args << "workspace" << QString::fromStdString(ws);
    i3_args << "workspace " + ws;
    QProcess::startDetached(i3_bin, i3_args);
}

void PlasmaI3Workspaces::waitForUpdate() {
    // QString i3_bin = "i3-msg";
    // QStringList i3_args;
    // i3_args << "-t" << "subscribe";
    // i3_args << "-m" << "'[ \"workspace\" ]'";
    // i3_args << "-t" << "subscribe" << "-m" << "'[\"workspace\"]'";
    // i3_process.start(i3_bin, i3_args);

    // QProcess i3_process;
    // i3_process.start("i3-msg", QStringList() << "-t" << "subscribe" << "[\"workspace\"]");
    // i3_process.waitForFinished();


    WorkerThread *wt = new WorkerThread();
    connect(wt, &WorkerThread::resultReady, this, &PlasmaI3Workspaces::handleResult);
    connect(wt, &WorkerThread::finished, wt, &QObject::deleteLater);
    wt->start();

    // i3_process.waitForReadyRead();
    // while (i3_process.state() == QProcess::Running) {
    //     qDebug()<<i3_process.readLine();
    // }
    // i3_process.terminate();
}

void PlasmaI3Workspaces::handleResult() {
    QString s;
    emit resultReady(s);
}

void PlasmaI3Workspaces::initMonitorModeChange() {
    ModeMonitor *mm = new ModeMonitor();
    connect(mm, &ModeMonitor::modeChangedReady, this, &PlasmaI3Workspaces::handleModeChanged);
    connect(mm, &ModeMonitor::finished, mm, &QObject::deleteLater);
    mm->start();
}

void PlasmaI3Workspaces::handleModeChanged(const QString &s) {
    emit modeChangedReady(s);
}

QString PlasmaI3Workspaces::getMessage() {
    QProcess i3_process;
    // QString i3_bin = "/usr/bin/i3";
    QString i3_bin = "i3-msg";
    QStringList i3_args;
    // i3_args << "workspace 1";
    i3_args << "-t" << "get_workspaces";
    i3_process.start(i3_bin, i3_args);

    i3_process.waitForFinished();

    QByteArray res = i3_process.readAllStandardOutput();

    // return "Hello World from c++";
    return QString(res);
}
