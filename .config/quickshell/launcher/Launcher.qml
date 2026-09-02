import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import "../globals"
import "../ui"

PanelWindow {
    id: window

    anchors { top: true; bottom: true; left: true; right: true }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.namespace: "launcher"
    exclusiveZone: 0

    color: "transparent"
    visible: false

    property var allApps: []
    property var filteredApps: []

    function toggle() {
        window.visible = !window.visible
        if (window.visible) {
            allApps = DesktopEntries.applications.values.filter(a => !a.noDisplay)
            allApps.sort((a, b) => a.name.localeCompare(b.name))
            searchField.text = ""
            filterApps()
            searchField.forceActiveFocus()
            appList.positionViewAtBeginning()
        }
    }

    IpcHandler {
        target: "launcher"
        function toggle(): void { window.toggle() }
        function show(): void {
            window.visible = true
            allApps = DesktopEntries.applications.values.filter(a => !a.noDisplay)
            allApps.sort((a, b) => a.name.localeCompare(b.name))
            searchField.text = ""
            filterApps()
            searchField.forceActiveFocus()
            appList.positionViewAtBeginning()
        }
        function hide(): void { window.visible = false }
    }

    MouseArea {
        id: bgMouse
        anchors.fill: parent
        onClicked: window.visible = false
        Keys.onEscapePressed: window.visible = false
    }

    Rectangle {
        id: launcherModal
        anchors.centerIn: parent
        width: 400
        height: 500
        color: Colors.md3.surface_container_high
        radius: 24
        border.color: Colors.md3.outline_variant
        border.width: 2
        clip: true

        MouseArea { anchors.fill: parent }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 12

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 52
                radius: 24
                color: Colors.md3.surface_container
                border.color: searchField.activeFocus ? Colors.md3.primary : Colors.md3.outline_variant
                border.width: searchField.activeFocus ? 2 : 1

                Behavior on border.color {
                    ColorAnimation { duration: 150 }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 12

                    QsText {
                        text: "󰍉"
                        color: Colors.md3.primary
                        font.pixelSize: 18
                    }

                    TextField {
                        id: searchField
                        Layout.fillWidth: true
                        placeholderText: "Search applications..."
                        placeholderTextColor: Colors.md3.outline
                        color: Colors.md3.on_surface
                        font.family: Config.fontName
                        font.pixelSize: 15
                        background: Item {}

                        onTextChanged: filterApps()

                        Keys.onPressed: (event) => {
                            if (event.key === Qt.Key_Down) {
                                if (appList.count > 0) {
                                    appList.currentIndex = Math.min(appList.currentIndex + 1, appList.count - 1)
                                    appList.positionViewAtIndex(appList.currentIndex, ListView.Contain)
                                }
                                event.accepted = true
                            } else if (event.key === Qt.Key_Up) {
                                if (appList.count > 0) {
                                    appList.currentIndex = Math.max(appList.currentIndex - 1, 0)
                                    appList.positionViewAtIndex(appList.currentIndex, ListView.Contain)
                                }
                                event.accepted = true
                            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                let selectedApp = filteredApps[appList.currentIndex]
                                if (selectedApp) {
                                    selectedApp.execute()
                                    window.visible = false
                                }
                                event.accepted = true
                            } else if (event.key === Qt.Key_Escape) {
                                window.visible = false
                                event.accepted = true
                            }
                        }
                    }

                    MouseArea {
                        visible: searchField.text.length > 0
                        implicitWidth: 20; implicitHeight: 20
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            searchField.text = ""
                            searchField.forceActiveFocus()
                        }
                        QsText { anchors.centerIn: parent; text: "󰅖"; font.pixelSize: 14; color: Colors.md3.on_surface_variant }
                    }
                }
            }

            // App List View
            ListView {
                id: appList
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 4
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                highlightFollowsCurrentItem: true
                highlightRangeMode: ListView.ApplyRange
                preferredHighlightBegin: 52
                preferredHighlightEnd: height - 52
                highlightMoveDuration: 150
                highlightMoveVelocity: -1
                model: filteredApps

                QsText {
                    anchors.centerIn: parent
                    visible: appList.count === 0
                    text: "No applications found"
                    font.pixelSize: 14
                    font.italic: true
                    color: Colors.md3.on_surface_variant
                }

                delegate: MouseArea {
                    id: delegateArea
                    required property var modelData
                    required property int index

                    width: appList.width
                    height: 52
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    readonly property bool isSelected: appList.currentIndex === index
                    readonly property bool isHovered: containsMouse

                    onClicked: {
                        modelData.execute()
                        window.visible = false
                    }

                    Rectangle {
                        anchors.fill: parent
                        anchors.leftMargin: 4
                        anchors.rightMargin: 4
                        radius: 30
                        color: isSelected
                               ? Colors.md3.surface_container_highest
                               : (isHovered ? Colors.md3.surface_container : "transparent")
                        border.color: isSelected ? Colors.md3.primary : "transparent"
                        border.width: isSelected ? 1 : 0

                        Behavior on color {
                            ColorAnimation { duration: 100 }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 14

                            IconImage {
                                Layout.preferredWidth: 28
                                Layout.preferredHeight: 28
                                source: {
                                    let icon = modelData.icon || modelData.id
                                    return Quickshell.iconPath(icon, "application-x-executable")
                                }
                            }

                            QsText {
                                Layout.fillWidth: true
                                text: modelData.name
                                color: isSelected ? Colors.md3.primary : Colors.md3.on_surface
                                font.pixelSize: 14
                                font.bold: isSelected
                                elide: Text.ElideRight
                            }

                            QsText {
                                visible: isSelected
                                text: "↵"
                                font.pixelSize: 13
                                font.bold: true
                                color: Colors.md3.primary
                            }
                        }
                    }
                }
            }
        }
    }

    function filterApps() {
        let query = searchField.text.toLowerCase().trim()
        if (query.length === 0) {
            filteredApps = allApps
        } else {
            filteredApps = allApps.filter(app => {
                let nameMatch = app.name.toLowerCase().includes(query)
                let genMatch = app.genericName && app.genericName.toLowerCase().includes(query)
                let commMatch = app.comment && app.comment.toLowerCase().includes(query)
                return nameMatch || genMatch || commMatch
            })
        }
        appList.currentIndex = 0
    }
}
