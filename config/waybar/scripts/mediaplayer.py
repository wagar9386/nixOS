#!/usr/bin/env python3
import json
import os
import sys
from gi.repository import Playerctl, GLib

def on_track_change(player, metadata, manager):
    track_info = {}
    
    # Grab Title and Artist
    title = metadata.get('string:title') if metadata.get('string:title') else "Unknown Title"
    artist = metadata.get('string:artist') if metadata.get('string:artist') else "Unknown Artist"
    
    # Grab Album Art URL
    art_url = metadata.get('string:mpris:artUrl')
    cover_path = ""
    
    if art_url and art_url.startswith('file://'):
        cover_path = art_url.replace('file://', '')

    track_info['text'] = f"󰎆 {artist} - {title}"
    track_info['tooltip'] = f"Song: {title}\nArtist: {artist}\nClick to View Album Art & Controls"
    track_info['class'] = player.get_property('playback-status').value_name.lower()
    
    # Pass the local path to the cover image so our CSS/Hover commands can find it
    track_info['alt'] = cover_path 

    sys.stdout.write(json.dumps(track_info) + '\n')
    sys.stdout.flush()

def on_player_appeared(manager, name):
    init_player(name)

def init_player(name):
    player = Playerctl.Player.new_from_name(name)
    player.connect('metadata', on_track_change, manager)
    manager.manage_player(player)

manager = Playerctl.PlayerManager()
manager.connect('name-appeared', on_player_appeared)

# Near the bottom of your config/waybar/scripts/mediaplayer.py:
for name in manager.get_property('player-names'):
    init_player(name)

# --- ADD THIS QUICK FALLBACK SO IT PRINTS ON LAUNCH ---
if not manager.get_property('players'):
    sys.stdout.write('{"text": "󰎆 No media playing", "class": "stopped"}\n')
    sys.stdout.flush()
# -----------------------------------------------------

loop = GLib.MainLoop()
loop.run()
