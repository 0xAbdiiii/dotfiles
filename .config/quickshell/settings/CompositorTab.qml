import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io
import "../globals"
import "../ui"

ScrollView {
    id: scrollRoot
    required property var rootApp
    Layout.fillWidth: true
    Layout.fillHeight: true
    clip: true
    contentWidth: availableWidth
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical: ScrollBar {
        parent: scrollRoot
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 4
        policy: ScrollBar.AsNeeded
        contentItem: Rectangle {
            implicitWidth: 4
            radius: 2
            color: Colors.md3.primary
            opacity: parent.hovered || parent.pressed ? 0.8 : 0.35
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
        background: Rectangle { implicitWidth: 4; color: "transparent" }
    }

    ColumnLayout {
        width: scrollRoot.availableWidth - 12
        spacing: 20

        QsText { text: "Compositor & Effects"; font.pixelSize: 24; font.bold: true; color: Colors.md3.on_surface }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 12

        QsText { text: "Hyprland Visual Effects"; font.pixelSize: 14; font.bold: true; color: Colors.md3.primary }

        // 1. Animations Toggle
        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: 64; radius: 12
            color: Colors.md3.surface_container
            border.color: Colors.md3.outline_variant; border.width: 1

            property bool enabledState: true

            Process { id: animProc }

            RowLayout {
                anchors.fill: parent; anchors.margins: 16
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    QsText { text: "Window Animations"; font.pixelSize: 14; font.bold: true; color: Colors.md3.on_surface; elide: Text.ElideRight; Layout.fillWidth: true }
                    QsText { text: "Global smooth motion and spring transitions"; font.pixelSize: 11; color: Colors.md3.on_surface_variant; elide: Text.ElideRight; Layout.fillWidth: true }
                }
                Item { Layout.fillWidth: true }

                Rectangle {
                    Layout.preferredWidth: 90; Layout.preferredHeight: 32; radius: 16
                    color: parent.parent.enabledState ? Colors.md3.primary : Colors.md3.surface_variant

                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            parent.parent.parent.enabledState = !parent.parent.parent.enabledState
                            animProc.command = ["hyprctl", "keyword", "animations:enabled", parent.parent.parent.enabledState ? "1" : "0"]
                            animProc.running = true
                        }
                    }

                    QsText {
                        anchors.centerIn: parent
                        text: parent.parent.parent.enabledState ? "ON" : "OFF"
                        font.pixelSize: 12; font.bold: true
                        color: parent.parent.parent.enabledState ? Colors.md3.on_primary : Colors.md3.on_surface_variant
                    }
                }
            }
        }

        // 2. Blur Toggle
        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: 64; radius: 12
            color: Colors.md3.surface_container
            border.color: Colors.md3.outline_variant; border.width: 1

            property bool enabledState: true

            Process { id: blurProc }

            RowLayout {
                anchors.fill: parent; anchors.margins: 16
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    QsText { text: "Window & Layer Blur"; font.pixelSize: 14; font.bold: true; color: Colors.md3.on_surface; elide: Text.ElideRight; Layout.fillWidth: true }
                    QsText { text: "Kawase background blur on translucent windows"; font.pixelSize: 11; color: Colors.md3.on_surface_variant; elide: Text.ElideRight; Layout.fillWidth: true }
                }
                Item { Layout.fillWidth: true }

                Rectangle {
                    Layout.preferredWidth: 90; Layout.preferredHeight: 32; radius: 16
                    color: parent.parent.enabledState ? Colors.md3.primary : Colors.md3.surface_variant

                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            parent.parent.parent.enabledState = !parent.parent.parent.enabledState
                            blurProc.command = ["hyprctl", "keyword", "decoration:blur:enabled", parent.parent.parent.enabledState ? "1" : "0"]
                            blurProc.running = true
                        }
                    }

                    QsText {
                        anchors.centerIn: parent
                        text: parent.parent.parent.enabledState ? "ON" : "OFF"
                        font.pixelSize: 12; font.bold: true
                        color: parent.parent.parent.enabledState ? Colors.md3.on_primary : Colors.md3.on_surface_variant
                    }
                }
            }
        }

        // 3. Drop Shadows Toggle
        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: 64; radius: 12
            color: Colors.md3.surface_container
            border.color: Colors.md3.outline_variant; border.width: 1

            property bool enabledState: true

            Process { id: shadowProc }

            RowLayout {
                anchors.fill: parent; anchors.margins: 16
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    QsText { text: "Window Drop Shadows"; font.pixelSize: 14; font.bold: true; color: Colors.md3.on_surface; elide: Text.ElideRight; Layout.fillWidth: true }
                    QsText { text: "Render depth shadows around tiled & floating windows"; font.pixelSize: 11; color: Colors.md3.on_surface_variant; elide: Text.ElideRight; Layout.fillWidth: true }
                }
                Item { Layout.fillWidth: true }

                Rectangle {
                    Layout.preferredWidth: 90; Layout.preferredHeight: 32; radius: 16
                    color: parent.parent.enabledState ? Colors.md3.primary : Colors.md3.surface_variant

                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            parent.parent.parent.enabledState = !parent.parent.parent.enabledState
                            shadowProc.command = ["hyprctl", "keyword", "decoration:shadow:enabled", parent.parent.parent.enabledState ? "1" : "0"]
                            shadowProc.running = true
                        }
                    }

                    QsText {
                        anchors.centerIn: parent
                        text: parent.parent.parent.enabledState ? "ON" : "OFF"
                        font.pixelSize: 12; font.bold: true
                        color: parent.parent.parent.enabledState ? Colors.md3.on_primary : Colors.md3.on_surface_variant
                    }
                }
            }
        }

        // 4. Inactive Dimming Toggle
        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: 64; radius: 12
            color: Colors.md3.surface_container
            border.color: Colors.md3.outline_variant; border.width: 1

            property bool enabledState: false

            Process { id: dimProc }

            RowLayout {
                anchors.fill: parent; anchors.margins: 16
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    QsText { text: "Dim Inactive Windows"; font.pixelSize: 14; font.bold: true; color: Colors.md3.on_surface; elide: Text.ElideRight; Layout.fillWidth: true }
                    QsText { text: "Dim unfocused windows to emphasize active workspace task"; font.pixelSize: 11; color: Colors.md3.on_surface_variant; elide: Text.ElideRight; Layout.fillWidth: true }
                }
                Item { Layout.fillWidth: true }

                Rectangle {
                    Layout.preferredWidth: 90; Layout.preferredHeight: 32; radius: 16
                    color: parent.parent.enabledState ? Colors.md3.primary : Colors.md3.surface_variant

                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            parent.parent.parent.enabledState = !parent.parent.parent.enabledState
                            dimProc.command = ["hyprctl", "keyword", "decoration:dim_inactive", parent.parent.parent.enabledState ? "1" : "0"]
                            dimProc.running = true
                        }
                    }

                    QsText {
                        anchors.centerIn: parent
                        text: parent.parent.parent.enabledState ? "ON" : "OFF"
                        font.pixelSize: 12; font.bold: true
                        color: parent.parent.parent.enabledState ? Colors.md3.on_primary : Colors.md3.on_surface_variant
                    }
                }
            }
        }
    }

        Item { Layout.fillHeight: true; Layout.preferredHeight: 20 }
    }
}
