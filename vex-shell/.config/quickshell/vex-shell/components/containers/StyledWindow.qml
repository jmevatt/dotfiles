import Quickshell
import Quickshell.Wayland

// qmllint disable uncreatable-type
PanelWindow {
    // qmllint enable uncreatable-type
    required property string name

    WlrLayershell.namespace: `vex-${name}`
    color: "transparent"
}
