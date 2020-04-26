#ifndef I3_WORKSPACES_PLASMOID_PLASMAI3WORKSPACES_H
#define I3_WORKSPACES_PLASMOID_PLASMAI3WORKSPACES_H

#include <QtCore/QObject>

#include <QProcess>
#include <QString>
#include <QStringList>
#include <QByteArray>

#include <QThread>

#include <QDebug>

class WorkspaceMonitor : public QThread
{
    Q_OBJECT
    void run() override {
        qDebug() << "started monitoring workspaces";
        QProcess i3_process;
        i3_process.start("i3-msg", QStringList() << "-t" << "subscribe" << "-m" << "[\"workspace\"]");
        i3_process.waitForStarted();
        while (i3_process.state() == QProcess::Running) {
            i3_process.waitForReadyRead();
            i3_process.readLine();
            emit workspaceChanged();
        }
        emit i3restarted();
    }
signals:
    void workspaceChanged();
    void i3restarted();
};

class ModeMonitor : public QThread
{
    Q_OBJECT
    void run() override {
        QProcess i3_process;
        i3_process.start("i3-msg", QStringList() << "-t" << "subscribe" << "-m" << "[\"mode\"]");
        i3_process.waitForStarted();
        while (i3_process.state() == QProcess::Running) {
            QString result;
            i3_process.waitForReadyRead();
            result = i3_process.readLine();
            emit modeChanged(result);
        }
    }
signals:
    void modeChanged(const QString &s);
};

class PlasmaI3Workspaces : public QObject {
    Q_OBJECT
public:
    explicit PlasmaI3Workspaces(QObject *parent = 0);

public Q_SLOTS:
    QString getWorkspaces();
    void goToWorkspace(QString);
    void initMonitoring();
    void handlei3restart();
    void handleWorkspaceChanged();
    void handleModeChanged(const QString &s);
signals:
    void workspaceChanged();
    void modeChanged(const QString &s);
    void i3restarted();
};


#endif //I3_WORKSPACES_PLASMOID_PLASMAI3WORKSPACES_H
