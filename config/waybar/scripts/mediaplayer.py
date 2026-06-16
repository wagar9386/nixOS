#!/usr/bin/env python3
import json
import os
import sys
import gi
gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl, GLib

def print_current_track(player):
    try:
        metadata = player.props.metadata
        if not metadata:
            return
            
        title = metadata.get('xesam:title') or metadata.get('string:title') or "Unknown Title"
        artist_data = metadata.get('xesam:artist') or metadata.get('string:artist') or "Unknown Artist"
        
        if isinstance(artist_data, list):
            artist = ", ".join(artist_data)
        else:
            artist = artist_data
            
        art_url = metadata.get('mpris:artUrl') or metadata.get('string:mpris:artUrl') or ""
        cover_path = art_url.replace('file://', '') if art_url.startswith('file://') else art_url

        track_info = {
            'text': f"󰎆 {artist} - {title}",
            'tooltip': f"Song: {title}\nArtist: {artist}\nClick to View Album Art & Controls",
            'class': player.get_property('playback-status').value_name.lower(),
            'alt': cover_path
        }
        
        sys.stdout.write(json.dumps(track_info) + '\n')
        sys.stdout.flush()
    except Exception as e:
        # Debug fallback to prevent silent loops
        sys.stderr.write(f"Error reading track data: {str(e)}\n")

def on_metadata(player, metadata):
    print_current_track(player)

def on_playback_status(player, status):
    print_current_track(player)

def on_player_vanished(manager, name):
    sys.stdout.write('{"text": "", "class": "stopped"}\n')
    sys.stdout.flush()

def init_player(player):
    player.connect('metadata', on_metadata)
    player.connect('playback-status', on_playback_status)
    print_current_track(player)

def on_player_appeared(manager, name):
    player = Playerctl.Player.new_from_name(name)
    init_player(player)

manager = Playerctl.PlayerManager()
manager.connect('name-appeared', on_player_appeared)
manager.connect('player-vanished', on_player_vanished)

# --- FORCE EXPLICIT INITIALIZATION FOR FEISHIN ---
try:
    # 1. First see if playerctl can find any active players globally
    players = manager.props.players
    
    # 2. If it returns empty, force create an explicit instance for Feishin
    if not players:
        feishin_player = Playerctl.Player.new_from_name('Feishin')
        players = [feishin_player]
        
    for player in players:
        init_player(player)
        
except Exception:
    sys.stdout.write('{"text": "󰎆 No media playing", "class": "stopped"}\n')
    sys.stdout.flush()
# -------------------------------------------------

loop = GLib.MainLoop()
loop.run()
