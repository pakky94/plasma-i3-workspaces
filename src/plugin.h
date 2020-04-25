#ifndef I3_WORKSPACES_PLASMOID_PLUGIN_H
#define I3_WORKSPACES_PLASMOID_PLUGIN_H

#include <QQmlExtensionPlugin>

class QQmlEngine;
class Plugin : public QQmlExtensionPlugin
{
Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
};

#endif //I3_WORKSPACES_PLASMOID_PLUGIN_H
