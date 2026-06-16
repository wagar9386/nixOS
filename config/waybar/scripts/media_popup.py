#!/usr/bin/env python3
import tkinter as tk
from subprocess import run, PIPE
import os

# Fetch metadata via playerctl
def get_metadata():
    title = run(["playerctl", "metadata", "title"], stdout=PIPE).stdout.decode('utf-8').strip()
    artist = run(["playerctl", "metadata", "artist"], stdout=PIPE).stdout.decode('utf-8').strip()
    art_url = run(["playerctl", "metadata", "mpris:artUrl"], stdout=PIPE).stdout.decode('utf-8').strip()
    return title, artist, art_url.replace("file://", "")

title, artist, cover_path = get_metadata()

# UI Window setup
root = tk.Tk()
root.title("Media Controller")
root.configure(bg='#282828') # Gruvbox bg0
root.geometry("300x400")

# Render Album Art if path exists
if cover_path and os.path.exists(cover_path):
    try:
        from PIL import Image, ImageTk
        img = Image.open(cover_path).resize((220, 220))
        photo = ImageTk.PhotoImage(img)
        lbl_img = tk.Label(root, image=photo, bg='#282828')
        lbl_img.pack(pady=15)
    except ImportError:
        pass # Fallback if Pillow library isn't installed

# Labels
lbl_title = tk.Label(root, text=title[:25], fg='#ebdbb2', bg='#282828', font=("JetBrainsMono Nerd Font", 12, "bold"))
lbl_title.pack()
lbl_artist = tk.Label(root, text=artist[:30], fg='#b8bb26', bg='#282828', font=("JetBrainsMono Nerd Font", 10))
lbl_artist.pack(pady=5)

# Button framework
btn_frame = tk.Frame(root, bg='#282828')
btn_frame.pack(pady=20)

tk.Button(btn_frame, text="󰒮", fg='#ebdbb2', bg='#3c3836', borderwidth=0, font=14, command=lambda: run(["playerctl", "previous"])).grid(row=0, column=0, padx=15)
tk.Button(btn_frame, text="󰐊", fg='#fabd2f', bg='#3c3836', borderwidth=0, font=14, command=lambda: run(["playerctl", "play-pause"])).grid(row=0, column=1, padx=15)
tk.Button(btn_frame, text="󰒭", fg='#ebdbb2', bg='#3c3836', borderwidth=0, font=14, command=lambda: run(["playerctl", "next"])).grid(row=0, column=2, padx=15)

root.mainloop()
