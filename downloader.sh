#!/bin/bash
BASE_PATH="/mnt/jellyfin_media"
MODE=$1
TARGET=$2
URLS=$3

# Ensure the mount is actually there before doing anything
if ! mountpoint -q "$BASE_PATH"; then
    echo "ERROR: NFS Mount at $BASE_PATH is not active."
    exit 1
fi

if [ "$MODE" == "search" ]; then
    # IF NO TARGET GIVEN: List existing top-level directories
    if [ -z "$TARGET" ] || [ "$TARGET" == "None" ]; then
        echo "NO_TARGET_PROVIDED. Existing categories are:"
        find "$BASE_PATH" -maxdepth 1 -type d -not -path "$BASE_PATH" | sed "s|$BASE_PATH/||"
    else
        # SEARCH FOR SIMILAR folders
        matches=$(find "$BASE_PATH" -maxdepth 2 -type d -iname "*$TARGET*" | sed "s|$BASE_PATH/||")
        if [ -z "$matches" ]; then
            echo "CLEAN"
        else
            echo "FOUND_SIMILAR:"
            echo "$matches"
        fi
    fi
    exit 0
fi

# --- Download mode (anything that isn't "search") ---
# $1 = subfolder name, $2 = space-separated URLs
TARGET_DIR="$BASE_PATH/$TARGET"
mkdir -p "$TARGET_DIR"

# Verify yt-dlp is available
if ! command -v yt-dlp &> /dev/null; then
    echo "ERROR: yt-dlp is not installed or not in PATH. Aborting."
    exit 1
fi

echo "Downloading to: $TARGET_DIR"
for URL in $URLS; do
    echo "→ Fetching: $URL"
    yt-dlp -P "$TARGET_DIR" --no-playlist "$URL"
done

echo "Done. All links processed."