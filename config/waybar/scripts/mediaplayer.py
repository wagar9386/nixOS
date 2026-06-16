#!/usr/bin/env python3
import subprocess
import json
import sys
import time

def escape_markup(text):
    # Prevents GTK/Pango markup exceptions from ruining layout parsing
    return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")

def listen_to_player():
    cmd = [
        "playerctl", "metadata",
        "--format", '{"title": "{{title}}", "artist": "{{artist}}", "status": "{{status}}", "art": "{{mpris:artUrl}}"}',
        "--follow"
    ]
    
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True)
    
    for line in proc.stdout:
        try:
            raw = json.loads(line.strip())
            
            title = raw.get("title") or "Unknown Title"
            artist = raw.get("artist") or "Unknown Artist"
            status = (raw.get("status") or "playing").lower()
            art = raw.get("art") or ""
            
            # Escape strings to make them safe for the GTK engine
            safe_title = escape_markup(title)
            safe_artist = escape_markup(artist)
            
            track_info = {
                "text": f"󰎆 {safe_artist} - {safe_title}",
                "tooltip": f"Song: {safe_title}\nArtist: {safe_artist}\nClick to View Album Art and Controls",
                "class": status,
                "alt": art.replace("file://", "") if art.startswith("file://") else art
            }
            
            sys.stdout.write(json.dumps(track_info) + '\n')
            sys.stdout.flush()
        except Exception:
            continue

while True:
    check = subprocess.run(["playerctl", "status"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if check.returncode != 0 or "No players found" in check.stderr:
        sys.stdout.write('{"text": "󰎆 No media playing", "class": "stopped"}\n')
        sys.stdout.flush()
        time.sleep(2)
    else:
        listen_to_player()
        time.sleep(1)
