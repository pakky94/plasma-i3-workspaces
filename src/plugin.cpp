#include <QtQml>
#include "plugin.h"
#include "plasmai3workspaces.h"


void Plugin::registerTypes(const char *uri) {
    qmlRegisterType<PlasmaI3Workspaces>("PlasmaI3Workspaces", 1, 0, "PlasmaI3Workspaces");
    // qmlRegisterType<WorkerThread>("PlasmaI3Workspaces", 1, 0, "WorkerThread");
}
