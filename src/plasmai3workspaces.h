#ifndef I3_WORKSPACES_PLASMOID_PLASMAI3WORKSPACES_H
#define I3_WORKSPACES_PLASMOID_PLASMAI3WORKSPACES_H

#include <QtCore/QObject>

#include <QProcess>
#include <QString>
#include <QStringList>
#include <QByteArray>

#include <QThread>

class WorkerThread : public QThread
{
    Q_OBJECT
    void run() override {
        QProcess i3_process;
        i3_process.start("i3-msg", QStringList() << "-t" << "subscribe" << "[\"workspace\"]");
        i3_process.waitForFinished();
        emit resultReady();
        // emit resultReady(result);
    }
signals:
    // void resultReady(const QString &s);
    void resultReady();
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
            emit modeChangedReady(result);
        }
    }
signals:
    void modeChangedReady(const QString &s);
};

class PlasmaI3Workspaces : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString getMessage READ getMessage)
public:
    explicit PlasmaI3Workspaces(QObject *parent = 0);

public Q_SLOTS:
    QString getMessage();
    QString getWorkspaces();
    void goToWorkspace(QString);
    void waitForUpdate();
    void initMonitorModeChange();
    // void handleResult(QString &s);
    void handleResult();
    void handleModeChanged(const QString &s);
signals:
    void resultReady(const QString &s);
    void modeChangedReady(const QString &s);
};


#endif //I3_WORKSPACES_PLASMOID_PLASMAI3WORKSPACES_H
