#!/usr/bin/env python3

import os
import sys
import dbus
import subprocess

def get_spotify_metadata():
    try:
        # Set DBUS environment
        bus = dbus.SessionBus()

        # Try Spotify first
        try:
            spotify_player = bus.get_object('org.mpris.MediaPlayer2.spotify', '/org/mpris/MediaPlayer2')
            player = dbus.Interface(spotify_player, 'org.freedesktop.DBus.Properties')

            metadata = player.Get('org.mpris.MediaPlayer2.Player', 'Metadata')
            status = player.Get('org.mpris.MediaPlayer2.Player', 'PlaybackStatus')

            artist = metadata.get('xesam:artist', ['Unknown Artist'])[0]
            title = metadata.get('xesam:title', 'Unknown Title')

            if status == 'Playing':
                return f"󰓇  {artist} - {title}"
            elif status == 'Paused':
                return f"󰏤  {artist} - {title}"

        except dbus.exceptions.DBusException:
            # Spotify not found, try any other player
            pass

        # Try any other media player
        for service in bus.list_names():
            if service.startswith('org.mpris.MediaPlayer2.') and service != 'org.mpris.MediaPlayer2.spotify':
                try:
                    player_obj = bus.get_object(service, '/org/mpris/MediaPlayer2')
                    player = dbus.Interface(player_obj, 'org.freedesktop.DBus.Properties')

                    metadata = player.Get('org.mpris.MediaPlayer2.Player', 'Metadata')
                    status = player.Get('org.mpris.MediaPlayer2.Player', 'PlaybackStatus')

                    if status in ['Playing', 'Paused']:
                        artist = metadata.get('xesam:artist', ['Unknown Artist'])[0]
                        title = metadata.get('xesam:title', 'Unknown Title')

                        # Get player name from service and use appropriate glyph
                        player_name = service.split('.')[-1].lower()
                        glyph = get_player_glyph(player_name, status)

                        return f"{glyph}  {artist} - {title}"

                except dbus.exceptions.DBusException:
                    continue

        # Execute the hyprctl command and return its output when no player is found
        result = subprocess.run(['hyprctl', 'splash'], capture_output=True, text=True)
        return result.stdout.strip()

    except Exception as e:
        # Execute the hyprctl command on error
        result = subprocess.run(['hyprctl', 'splash'], capture_output=True, text=True)
        return result.stdout.strip()

def get_player_glyph(player_name, status):
    """Return appropriate glyph based on player name and status"""
    glyphs = {
        'spotify': {'playing': '󰓇', 'paused': '󰏤'},
        'vlc': {'playing': '󰕼', 'paused': '󰏤'},
        'firefox': {'playing': '󰈹', 'paused': '󰏤'},
        'chrome': {'playing': '󰊯', 'paused': '󰏤'},
        'mpv': {'playing': '󰎁', 'paused': '󰏤'},
        'default': {'playing': '󰎈', 'paused': '󰏤'}
    }

    status_key = 'playing' if status == 'Playing' else 'paused'

    # Try to find specific player glyph, fall back to default
    if player_name in glyphs:
        return glyphs[player_name][status_key]
    else:
        return glyphs['default'][status_key]

if __name__ == "__main__":
    try:
        print(get_spotify_metadata())
    except:
        # Execute the hyprctl command if everything fails
        result = subprocess.run(['hyprctl', 'splash'], capture_output=True, text=True)
        print(result.stdout.strip())
