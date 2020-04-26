import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.4 as Kirigami

Item {
    id: page
    width: childrenRect.width
    height: childrenRect.height

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        ConfigColor {
            label: "Text"
            configKey: 'textColor'
            horizontalAlignment: 150
            // defaultColor: theme.textColor
        }
        ConfigColor {
            label: "Workspace normal"
            configKey: 'borderNormalWsColor'
            horizontalAlignment: 150
            // defaultColor: theme.textColor
        }
        ConfigColor {
            label: "Workspace visible"
            configKey: 'borderVisibleWsColor'
            // defaultColor: theme.textColor
        }
        ConfigColor {
            label: "Workspace focused "
            configKey: 'borderFocusedWsColor'
            // defaultColor: theme.textColor
        }
        ConfigColor {
            label: "Workspace urgent"
            configKey: 'borderUrgentWsColor'
            // defaultColor: theme.textColor
        }
        ConfigColor {
            label: "Mode"
            configKey: 'borderModeColor'
            // defaultColor: theme.textColor
        }
    }
}

