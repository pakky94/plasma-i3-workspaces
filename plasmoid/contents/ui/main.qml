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
    // Plasmoid.compactRepresentation: ToolBar {
        property var is_updating: 0
        property var old_layout: ""
        property var current_mode: "default"
        property var old_mode: ""
        property var mode_text_width: 0

        id: toolbar

        // spacing: 50
        // width: 500
        // width: row_container.implicitWidth
        // anchors.fill: parent

        PlasmaI3Workspaces {
            id: plasmai3workspaces
            onResultReady: {
                is_updating = is_updating - 1;
                updateOutText();
                if (is_updating == 0) {
                    this.waitForUpdate();
                    is_updating = is_updating + 1;
                }
            }
            onModeChangedReady: {
                var input = JSON.parse(s);
                // var text = input.change;
                current_mode = input.change;
                updateOutText();
                // console.log(s);
                // if (text.localeCompare("default") == 0) {
                //     mode_view.set_text("");
                //     mode_view.width = 0
                //     mode_text_width = 0
                //     mode_view.border.color = "#00000000"
                // } else {
                //     mode_view.set_text(text);
                //     mode_view_text_metrics.text = text;
                //     mode_view.width = mode_view_text_metrics.width + 10;
                //     mode_text_width = mode_view_text_metrics.width + 10;
                //     mode_view.border.color = "red"
                // }
            }
        }

        TextMetrics {
            id: mode_view_text_metrics
            font.family: "Arial"
            font.pixelSize: 15
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
                // count = count + 1
                // output.text = count
                // var count_w = mode_text_width;
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
                            // "workspace_number": w.num,
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
                // toolbar.width = count_w + mode_text_width
                // container_item.implicitWidth = 20 * count_w
                out_view.implicitWidth = count_w + mode_text_width
                old_layout = input_str
                old_mode = current_mode
            } else {
                // console.log("skip");
            }
        }

        Timer {
            interval: 100
            running: true
            repeat: false
            onTriggered: {
                plasmai3workspaces.initMonitorModeChange();
            }
        }

        Timer {
            interval: 20000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                updateOutText();
                plasmai3workspaces.waitForUpdate();
                is_updating = is_updating + 1

                // console.log("end");
            }
        }

        Component {
            id: workspaceDelegate
            Rectangle {
                // width: 20
                // height: 20
                // anchors.centerIn: parent
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
                    // text: w_name
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

        // Row {
        //     id: row_container
        //     anchors.fill: parent
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

        // Rectangle {
        //     // property var mode_text: "test"
        //     // property var mode_width: 50
        //     function set_text(t) {
        //         mode_text_metrics.text = t;
        //     }

        //     id: mode_view
        //     // anchors.centerIn: parent
        //     anchors.top: parent.top
        //     anchors.left: out_view.right

        //     width: 1
        //     height: 20
        //     color: "#00000000"
        //     border.color: "#00000000"
        //     border.width: 2
        //     TextMetrics {
        //         id: mode_text_metrics
        //         font.family: "Arial"
        //         font.pixelSize: 15
        //         text: ""
        //     }
        //     Text {
        //         id: mode_text
        //         anchors.centerIn: parent
        //         color: "#dddddd"
        //         // text: w_name
        //         text: mode_text_metrics.text
        //         font: mode_text_metrics.font
        //     }
        // }
        // }
    }
}
