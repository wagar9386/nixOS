#!/usr/bin/env python3
import subprocess
import json
import sys
import time

def listen_to_player():
    # Tell playerctl to dump raw metadata as a simple JSON string and follow it continuously
    cmd = [
        "playerctl", "metadata",
        "--format", '{"title": "{{title}}", "artist": "{{artist}}", "status": "{{status}}", "art": "{{mpris:artUrl}}"}',
        "--follow"
    ]
    
    # Spawn the process
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True)
    
    # Stream lines instantly as playerctl emits them
    for line in proc.stdout:
        try:
            raw = json.loads(line.strip())
            
            title = raw.get("title") or "Unknown Title"
            artist = raw.get("artist") or "Unknown Artist"
            status = (raw.get("status") or "playing").lower()
            art = raw.get("art") or ""
            
            # Format the exact structure your Waybar JSON config expects
            track_info = {
                "text": f"󰎆 {artist} - {title}",
                "tooltip": f"Song: {title}\nArtist: {artist}\nClick to View Album Art & Controls",
                "class": status,
                "alt": art.replace("file://", "") if art.startswith("file://") else art
            }
            
            sys.stdout.write(json.dumps(track_info) + '\n')
            sys.stdout.flush()
        except Exception:
            continue

while True:
    # Check if any media player session is running right now
    check = subprocess.run(["playerctl", "status"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    
    if check.returncode != 0 or "No players found" in check.stderr:
        # Clear the bar and print the idle state if nothing is active
        sys.stdout.write('{"text": "󰎆 No media playing", "class": "stopped"}\n')
        sys.stdout.flush()
        time.sleep(2) # Polling throttle while inactive
    else:
        # A player exists! Hook directly into the live data stream
        listen_to_player()
        time.sleep(1)
