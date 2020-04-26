import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.3
import QtQuick.Dialogs 1.3
import QtQuick.Controls.Styles 1.3
import PlasmaI3Workspaces 1.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

Item {

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: PlasmaComponents.ToolBarLayout {
        property var is_updating: 0
        property var old_layout: ""
        property var current_mode: "default"
        property var old_mode: ""
        property var mode_text_width: 0

        id: toolbar

        PlasmaI3Workspaces {
            id: plasmai3workspaces
            onWorkspaceChanged: {
                is_updating = is_updating - 1;
                updateOutText();
                if (is_updating == 0) {
                    this.waitForUpdate();
                    is_updating = is_updating + 1;
                }
            }
            onModeChanged: {
                var input = JSON.parse(s);
                current_mode = input.change;
                updateOutText();
            }
            onI3restarted: {
                restart_timer.start();
            }
        }

        TextMetrics {
            id: textMetrics
            font.family: "Arial"
            font.pixelSize: 15
        }
        function updateOutText() {
            var input_str = plasmai3workspaces.getWorkspaces();
            if (input_str.localeCompare(old_layout) != 0
                || current_mode.localeCompare(old_mode)) {
                var input = JSON.parse(input_str);
                var count_w = 0;
                workspaceModel.clear();

                var last_out = input[0].output;
                input.forEach(w => {

                    if (last_out.localeCompare(w.output) != 0) {
                        workspaceModel.append({
                            "b_color": "transparent",
                            "w_name": "",
                            "w_text": ""
                        });
                        count_w = count_w + 22
                        last_out = w.output;
                    }

                    textMetrics.text = w.name
                    count_w = count_w + 2 + Math.max(20, textMetrics.width + 10)

                    var b_color = "#787878"
                    if (w.visible == true)
                        b_color = "#dddddd"
                    if (w.focused == true)
                        b_color = "blue"
                    else if (w.urgent == true)
                        b_color = "red"
                    workspaceModel.append(
                        {
                            "w_name": w.name,
                            "w_text": w.name,
                            "b_color": b_color
                        });
                })
                out_view.implicitWidth = count_w

                if (current_mode.localeCompare("default") != 0){
                    textMetrics.text = current_mode;
                    count_w = count_w + 24 + Math.max(20, textMetrics.width + 10);
                    workspaceModel.append({
                        "w_name": "",
                        "w_text": "",
                        "b_color": "#00000000"
                    });
                    workspaceModel.append({
                        "w_name": "",
                        "w_text": current_mode,
                        "b_color": "red"
                    });
                }
                out_view.implicitWidth = count_w + mode_text_width
                old_layout = input_str
                old_mode = current_mode
            }
        }

        Timer {
            id: restart_timer
            interval: 300
            running: true
            repeat: false
            triggeredOnStart: false
            onTriggered: {
                plasmai3workspaces.initMonitoring();
                updateOutText();
            }
        }

        Component {
            id: workspaceDelegate
            Rectangle {
                width: Math.max(textMetrics.width + 10, 20)
                height: Math.max(textMetrics.height, 20)
                color: "#00000000"
                border.color: b_color
                border.width: 2
                MouseArea {
                    anchors.fill: parent
                    anchors.centerIn: parent
                    onClicked: {
                        if (w_name != "")
                            plasmai3workspaces.goToWorkspace(w_name)
                    }
                }
                Text {
                    anchors.centerIn: parent
                    color: "#dddddd"
                    text: textMetrics.text
                    font: textMetrics.font
                }
                TextMetrics {
                    id: textMetrics
                    font.family: "Arial"
                    font.pixelSize: 15
                    text: w_text
                }
            }
        }
        ListModel {
            id: workspaceModel
        }
        ListView {
            id: out_view
            anchors.top: parent.top
            anchors.left: parent.left
            // anchors.fill: parent
            model: workspaceModel
            delegate: workspaceDelegate
            orientation: ListView.Horizontal
            spacing: 1
        }
    }
}
