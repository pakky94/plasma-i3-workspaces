#include "plasmai3workspaces.h"

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
    i3_args << "workspace " + ws;
    QProcess::startDetached(i3_bin, i3_args);
}

void PlasmaI3Workspaces::initMonitoring() {
    WorkspaceMonitor *wm = new WorkspaceMonitor();
    connect(wm, &WorkspaceMonitor::workspaceChanged, this, &PlasmaI3Workspaces::handleWorkspaceChanged);
    connect(wm, &WorkspaceMonitor::i3restarted, this, &PlasmaI3Workspaces::handlei3restart);
    connect(wm, &WorkspaceMonitor::finished, wm, &QObject::deleteLater);
    wm->start();

    ModeMonitor *mm = new ModeMonitor();
    connect(mm, &ModeMonitor::modeChanged, this, &PlasmaI3Workspaces::handleModeChanged);
    connect(mm, &ModeMonitor::finished, mm, &QObject::deleteLater);
    mm->start();
}

void PlasmaI3Workspaces::handleWorkspaceChanged() {
    emit workspaceChanged();
}

void PlasmaI3Workspaces::handleModeChanged(const QString &s) {
    emit modeChanged(s);
}

void PlasmaI3Workspaces::handlei3restart() {
    emit i3restarted();
}
