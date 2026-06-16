#!/usr/bin/env python3
import tkinter as tk
from subprocess import run, PIPE
import os
import urllib.request
import io
from PIL import Image, ImageTk

# Fetch active track context via playerctl CLI
def get_metadata():
    title = run(["playerctl", "metadata", "title"], stdout=PIPE).stdout.decode('utf-8').strip()
    artist = run(["playerctl", "metadata", "artist"], stdout=PIPE).stdout.decode('utf-8').strip()
    art_url = run(["playerctl", "metadata", "mpris:artUrl"], stdout=PIPE).stdout.decode('utf-8').strip()
    return title, artist, art_url

title, artist, art_url = get_metadata()

# UI Base Frame Container Configuration
root = tk.Tk()
root.title("Media Controller")
root.configure(bg='#282828') # Gruvbox Dark bg0
root.geometry("300x400")

# Pull artwork gracefully across local paths vs HTTP server parameters
photo = None
if art_url:
    try:
        if art_url.startswith('http://') or art_url.startswith('https://'):
            # Stream directly from your Navidrome server into the memory buffer
            with urllib.request.urlopen(art_url, timeout=3) as response:
                image_bytes = response.read()
            img = Image.open(io.BytesIO(image_bytes)).resize((220, 220))
        else:
            # Fall back to local file parsing
            clean_path = art_url.replace("file://", "")
            img = Image.open(clean_path).resize((220, 220))
            
        photo = ImageTk.PhotoImage(img)
        lbl_img = tk.Label(root, image=photo, bg='#282828')
        lbl_img.pack(pady=15)
    except Exception:
        pass # Fall back to structural text blocks if the server connection drops

# Labels
lbl_title = tk.Label(root, text=title[:25], fg='#ebdbb2', bg='#282828', font=("JetBrainsMono Nerd Font", 12, "bold"))
lbl_title.pack()
lbl_artist = tk.Label(root, text=artist[:30], fg='#b8bb26', bg='#282828', font=("JetBrainsMono Nerd Font", 10))
lbl_artist.pack(pady=5)

# Control Deck Structure
btn_frame = tk.Frame(root, bg='#282828')
btn_frame.pack(pady=20)

tk.Button(btn_frame, text="󰒮", fg='#ebdbb2', bg='#3c3836', borderwidth=0, font=14, command=lambda: run(["playerctl", "previous"])).grid(row=0, column=0, padx=15)
tk.Button(btn_frame, text="󰐊", fg='#fabd2f', bg='#3c3836', borderwidth=0, font=14, command=lambda: run(["playerctl", "play-pause"])).grid(row=0, column=1, padx=15)
tk.Button(btn_frame, text="󰒭", fg='#ebdbb2', bg='#3c3836', borderwidth=0, font=14, command=lambda: run(["playerctl", "next"])).grid(row=0, column=2, padx=15)

root.mainloop()
