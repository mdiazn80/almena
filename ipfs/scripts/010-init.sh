#!/bin/sh

WEBUI=https://github.com/ipfs/ipfs-webui/releases/download/v${IPFS_WEBUI_VERSION}/ipfs-webui@v${IPFS_WEBUI_VERSION}.car
DEST="./tmp/ipfs-webui.car"

if [ -f "$DEST" ]; then
    echo "✅ File Exists: $DEST"
else
    echo "⬇️  Downloading $WEBUI ..."
    wget -q --no-check-certificate "$WEBUI" -O "$DEST"

    if [ $? -eq 0 ]; then
        echo "✅ Download completed: $DEST"
        echo "📥 Importing WebUI CAR into IPFS ..."
        ipfs dag import "$DEST"
    else
        echo "❌ Error downloading $WEBUI"
        rm -f "$DEST"  # remove corrupt file if download fails
    fi
fi
