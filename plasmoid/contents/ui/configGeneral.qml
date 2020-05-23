import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.4 as Kirigami

Item {
    id: page
    width: childrenRect.width
    height: childrenRect.height

    // property alias cfg_showLabel: showLabel.checked
    // property alias cfg_showIcon: showIcon.checked
    property alias cfg_textFont: fontFamily.text
    property alias cfg_textSize: textSize.value
    property alias cfg_outputs: outputs.text

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        TextField {
            id: fontFamily
            Kirigami.FormData.label: i18n ("Font:")
            placeholderText: i18n("font")
        }
        SpinBox {
            id: textSize
            Kirigami.FormData.label: i18n ("Size:")
        }
        TextField {
            id: outputs
            Kirigami.FormData.label: i18n ("Outputs:")
            placeholderText: i18n("")
        }

    }
}
