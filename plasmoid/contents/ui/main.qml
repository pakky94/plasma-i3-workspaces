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
                updateOutText();
            }
            onModeChanged: {
                if (s.localeCompare("") != 0) {
                    var input = JSON.parse(s);
                    current_mode = input.change;
                    updateOutText();
                }
            }
            onI3restarted: {
                restart_timer.start();
            }
        }

        TextMetrics {
            id: textMetrics
            font.family: plasmoid.configuration.textFont
            font.pixelSize: plasmoid.configuration.textSize
        }
        function updateOutText() {
            var input_str = plasmai3workspaces.getWorkspaces();
            if (input_str.localeCompare(old_layout) != 0
                || current_mode.localeCompare(old_mode)) {
                var input = JSON.parse(input_str);
                var count_w = 0;
                workspaceModel.clear();

                var outputs = plasmoid.configuration.outputs;
                if (outputs.localeCompare("") != 0) {
                    var ordered_input = [];
                    outputs = outputs.split(" ");
                    outputs.forEach(o => {
                        input.forEach(w => {
                            if (o.localeCompare(w.output) == 0) {
                                ordered_input.push(w);
                            }
                        })
                    })
                    input = ordered_input;
                }

                var last_out = input[0].output;
                input.forEach(w => {

                    if (last_out.localeCompare(w.output) != 0) {
                        workspaceModel.append({
                            "b_color": "transparent",
                            "w_name": "",
                            "w_text": "",
                            "r_width": 20
                        });
                        count_w = count_w + 22
                        last_out = w.output;
                    }

                    textMetrics.text = w.name
                    count_w = count_w + 2 + Math.max(20, textMetrics.width + 10)

                    var b_color = plasmoid.configuration.borderNormalWsColor
                    if (w.visible == true)
                        b_color = plasmoid.configuration.borderVisibleWsColor
                    if (w.focused == true)
                        b_color = plasmoid.configuration.borderFocusedWsColor
                    else if (w.urgent == true)
                        b_color = plasmoid.configuration.borderUrgentWsColor
                    workspaceModel.append(
                        {
                            "w_name": w.name,
                            "w_text": w.name,
                            "b_color": b_color.toString(),
                            "r_width": Math.max(textMetrics.width + 10, 20)
                        });
                })
                out_view.implicitWidth = count_w

                if (current_mode.localeCompare("default") != 0){
                    textMetrics.text = current_mode;
                    count_w = count_w + 24 + Math.max(20, textMetrics.width + 10);
                    workspaceModel.append({
                        "w_name": "",
                        "w_text": "",
                        "b_color": "#00000000",
                        "r_width": 20
                    });
                    workspaceModel.append({
                        "w_name": "",
                        "w_text": current_mode,
                        "b_color": plasmoid.configuration.borderModeColor.toString(),
                        "r_width": Math.max(textMetrics.width + 10, 20)
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
                // width: Math.max(textMetrics.width + 10, 20)
                // height: Math.max(textMetrics.height, 20)
                width: r_width
                height: 20
                color: "#00000000"
                border.color: b_color
                // border.color: plasmoid.configuration.borderNormalWsColor
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
                    color: plasmoid.configuration.textColor
                    text: w_text
                    font.family: plasmoid.configuration.textFont
                    font.pixelSize: plasmoid.configuration.textSize
                }
                // TextMetrics {
                //     id: textMetrics
                //     font.family: "Arial"
                //     font.pixelSize: 15
                //     text: w_text
                // }
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
