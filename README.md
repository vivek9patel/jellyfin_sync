# media_sync — OpenClaw skill

```bash
openclaw skills install media-sync
```

An [OpenClaw](https://openclaw.ai) skill that downloads media with `yt-dlp` into a fixed library root, checks folders before writing, waits for your confirmation, and exposes download progress on demand. Works with any layout you keep under that root (Plex, Jellyfin, plain folders, etc.).

---

## ✨ Features

- **Folder check first** — `check_or_suggest_folder` runs before any download (exact match, similar names under the right parent path, or a clean path to create)
- **No download without confirm** — full destination shown; agent waits for approval, then calls `download_media`
- **Batch downloads** — multiple URLs in one message as one space-separated string, one tool call
- **Live progress** — `check_download_status` reports session state, per-file percent, speed, ETA, size, and errors
- **yt-dlp** — merges to MKV, single-video mode (`--no-playlist`), progress under `/tmp/media_sync_*.log`

---

## 📋 Prerequisites

### yt-dlp (in the environment that runs the skill)

```bash
# macOS
brew install yt-dlp

# Linux
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp
```

### Media root (fixed path)

Scripts use **`/mnt/jellyfin_media`** as the download root (intentional constant: mount your media library there in the OpenClaw/container runtime). The skill name is generic; the mount path is not.

### Skills install path (fixed)

Install this repo as **`~/.openclaw/skills/media_sync`** (same on the host and under `/home/$USER/.openclaw/skills/media_sync` in the container). `manifest.yaml` points at that path; do not rely on a separate skills-dir variable.

---

## 🚀 Installation

### Option A — Via ClawHub CLI (recommended)

```bash
npm install -g clawhub
clawhub install media_sync
```

### Option B — Manual install

Clone into **`media_sync`** so paths match `manifest.yaml`:

```bash
git clone https://github.com/YOUR_USERNAME/media_sync ~/.openclaw/skills/media_sync
chmod +x ~/.openclaw/skills/media_sync/*.sh
```

If your repo directory name differs, either clone into `~/.openclaw/skills/media_sync` anyway or edit the `command` paths in `manifest.yaml`.

Restart the OpenClaw gateway:

```bash
openclaw gateway restart
```

Inside the container, tools run from `/home/$USER/.openclaw/skills/media_sync/`.

---

## 🗂️ Skill files

```
media_sync/
├── SKILL.md                    # Agent rules + workflow
├── manifest.yaml               # Tool definitions (skill id: media_sync)
├── check_or_suggest_folder.sh
├── downloader.sh
└── check_download_status.sh
```

---

## 💬 Usage

Talk to the agent naturally. Examples:

**Existing folder:**

```
Download this into Hollywood:
https://www.youtube.com/watch?v=example
```

**Nested path (e.g. show / season):**

```
Put this in Shows/Breaking Bad/Season 2:
https://...
```

**No folder named** — agent lists top-level folders under `/mnt/jellyfin_media` and asks you to pick.

**Batch:**

```
Add these to Bollywood:
https://... https://... https://...
```

**Progress** — after a download starts, ask any way you like (“status?”, “how’s the download?”); the agent calls `check_download_status`.

---

## 🔄 What the agent does (paradigm)

1. **`check_or_suggest_folder`** — always first. Pass `folder_name` (e.g. `Hollywood`, `Shows/Breaking Bad/Season 2`) or empty string to list top-level dirs.
2. **Interpret status** and show you paths in plain language:
   - **FOUND_EXACT** — folder exists
   - **FOUND_SIMILAR** — close matches (paths are under the correct parent for nested names)
   - **CLEAN** — nothing matches; safe to create that path
   - **NO_TARGET_PROVIDED** — you didn’t specify a folder; pick from the listed top-level list
   - **ERROR** — e.g. root missing; surface the message as given
3. **Wait for your confirmation** — no `download_media` until you agree on the destination.
4. **`download_media(subfolder, links)`** — `subfolder` is relative to `/mnt/jellyfin_media`; `links` is one string of space-separated URLs. Session log: `/tmp/media_sync_progress.log`; per-file snapshots: `/tmp/media_sync_snap_<session>_<n>.log`.
5. **`check_download_status`** — when you want an update: overall progress, active file, per-file details, or **IDLE** if there’s no recent session.

The skill instructs terse “caveman” replies from the agent (short, data-first); that’s intentional in `SKILL.md`.

---

## ⚙️ Custom media root

The download root is hardcoded as **`ROOT="/mnt/jellyfin_media"`** in `check_or_suggest_folder.sh` and `downloader.sh`. To use another path, change `ROOT` in both files and update `manifest.yaml` text the model sees so it stays accurate.

---

## 🔗 Links

- [OpenClaw](https://openclaw.ai)
- [ClawHub Registry](https://clawhub.ai)
- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [Jellyfin](https://jellyfin.org) (optional; one common consumer of a media tree)
