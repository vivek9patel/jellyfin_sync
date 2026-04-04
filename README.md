# 🦞 jellyfin_sync — OpenClaw Skill

An [OpenClaw](https://openclaw.ai) skill that intelligently downloads media links directly into your [Jellyfin](https://jellyfin.org) library using `yt-dlp`. It acts as a cautious media librarian — always checking for existing folders before downloading, confirming paths with you, and keeping your library tidy.

---

## ✨ Features

- 🔍 **Folder search** — checks for existing or similar folders before every download to avoid duplicates
- ✅ **Path confirmation** — always shows the full destination path and waits for your approval before starting
- 📦 **Batch downloads** — pass multiple URLs in one message and they all download together
- ⚙️ **yt-dlp powered** — uses `yt-dlp` exclusively;

---

## 📋 Prerequisites

Before installing this skill, make sure the following are in place:

### 1. yt-dlp
```bash
# macOS
brew install yt-dlp

# Linux
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp
```
---

## 🚀 Installation

### Option A — Via ClawHub CLI (recommended)
```bash
# Install the ClawHub CLI if you haven't already
npm install -g clawhub

# Install the skill into your OpenClaw workspace
clawhub install jellyfin-sync
```

### Option B — Manual install
```bash
# Clone this repo into your OpenClaw skills directory
git clone https://github.com/YOUR_USERNAME/jellyfin_sync ~/.openclaw/skills/jellyfin_sync

# Make the shell script executable
chmod +x ~/.openclaw/skills/jellyfin_sync/downloader.sh
```

Then restart the OpenClaw gateway to pick it up:
```bash
openclaw gateway restart
```

---

## 🗂️ Skill Files

```
jellyfin_sync/
├── SKILL.md          # Instructions and rules for the AI agent
├── manifest.yaml     # Tool definitions (check_folder_exists, sync_media)
└── downloader.sh     # Shell script that handles search and yt-dlp downloads
```

---

## 💬 Usage

Once installed, just talk to your OpenClaw agent naturally:

**Download to an existing folder:**
```
Download this video into my Hollywood folder:
https://www.youtube.com/watch?v=example
```

**Download without specifying a folder** (agent will list available folders and ask):
```
Download this: https://www.youtube.com/watch?v=example
```

**Batch download multiple links:**
```
Add these to Bollywood:
https://www.youtube.com/watch?v=example1
https://www.youtube.com/watch?v=example2
https://www.youtube.com/watch?v=example3
```

### What the agent does behind the scenes

1. **Calls `check_folder_exists`** first — always, no exceptions
2. Shows you matching/similar folders or lists all available ones
3. **Waits for your confirmation** on the full destination path (e.g. `/mnt/jellyfin_media/Hollywood`)
4. Calls `sync_media` which runs `yt-dlp` into the confirmed folder
5. Reports success or any errors per link

---

## ⚙️ Configuration

| Environment Variable   | Default               | Description                          |
|------------------------|-----------------------|--------------------------------------|
| `JELLYFIN_MEDIA_PATH`  | `/mnt/jellyfin_media` | Root path of your Jellyfin media folder |

Set it in your shell profile:
```bash
export JELLYFIN_MEDIA_PATH="/your/custom/media/path"
```

---

## 🔗 Links

- [OpenClaw](https://openclaw.ai)
- [ClawHub Registry](https://clawhub.ai)
- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [Jellyfin](https://jellyfin.org)
