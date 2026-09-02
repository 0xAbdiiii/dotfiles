import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Mpris
import "../globals"
import "../ui"

Pill {
    id: root
    clickable: true
    paddingHorizontal: 14

    readonly property var activeMedia: (typeof globalMediaCenter !== "undefined" && globalMediaCenter) ? globalMediaCenter.player : null

    onClicked: (mouse) => {
        if (typeof globalMediaCenter !== "undefined" && globalMediaCenter) globalMediaCenter.toggle()
    }

    onRightClicked: (mouse) => {
        if (root.activeMedia) root.activeMedia.togglePlaying()
    }

    onMiddleClicked: (mouse) => {
        if (root.activeMedia) root.activeMedia.next()
    }

    onWheelScrolled: (wheel) => {
        if (root.activeMedia && root.activeMedia.canControl) {
            let delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05
            root.activeMedia.volume = Math.max(0.0, Math.min(1.0, root.activeMedia.volume + delta))
        }
    }

    RowLayout {
        spacing: 8

        QsText {
            text: root.activeMedia && root.activeMedia.playbackState === MprisPlaybackState.Playing ? "󰏤" : "󰐊"
            color: Colors.md3.primary
            font.pixelSize: 14
        }

        Item {
            Layout.maximumWidth: 220
            Layout.preferredWidth: Math.min(trackText.implicitWidth, 220)
            implicitHeight: trackText.implicitHeight
            clip: true

            QsText {
                id: trackText
                text: root.activeMedia 
                      ? (root.activeMedia.trackArtist ? `${root.activeMedia.trackArtist} • ${root.activeMedia.trackTitle}` : (root.activeMedia.trackTitle || "Playing"))
                      : "Music"
                font.italic: !root.activeMedia
                elide: Text.ElideRight
            }
        }
    }
}
