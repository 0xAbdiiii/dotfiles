import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland // Native Wayland ToplevelManager
import Quickshell.Widgets
import "../globals"
import "../ui"
import "../osd"
import "../quicksettings"

RowLayout {
    id: root
    spacing: 0
    readonly property bool hasItems: repeater.count > 0

    Repeater {
        id: repeater
        model: ToplevelManager.toplevels.values

        delegate: MouseArea {
            required property var modelData

            visible: modelData && modelData.appId !== "Alacritty"

            property bool isActive: modelData ? modelData.activated : false
            property bool isHovered: containsMouse

            implicitWidth: visible ? (20 + (isActive ? 24 : 6)) : 0
            implicitHeight: visible ? 24 : 0
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            acceptedButtons: Qt.LeftButton | Qt.MiddleButton
            onClicked: (mouse) => {
                if (!modelData) return
                if (mouse.button === Qt.LeftButton) {
                    modelData.activate()
                } else if (mouse.button === Qt.MiddleButton) {
                    modelData.close()
                }
            }

            readonly property string appIconName: {
                if (!modelData) return ""
                let entry = DesktopEntries.heuristicLookup(modelData.appId)
                return (entry && entry.icon) ? entry.icon : modelData.appId
            }

            Rectangle {
                anchors.fill: parent
                radius: 9
                color: isActive ? Colors.md3.primary : (isHovered ? Colors.md3.secondary : "transparent")

                Behavior on color { ColorAnimation { duration: 300 } }

                IconImage {
                    anchors.centerIn: parent
                    width: 20
                    height: 20
                    source: Quickshell.iconPath(appIconName, "application-x-executable")
                }
            }

            Behavior on implicitWidth {
                NumberAnimation { duration: 400; easing.type: Easing.OutBack }
            }
        }
    }
}
