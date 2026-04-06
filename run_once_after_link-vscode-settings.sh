#!/bin/bash

SOURCE="$HOME/.local/share/chezmoi/common/vscode-settings.json"

# macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    DEST="$HOME/Library/Application Support/Code/User/settings.json"
    mkdir -p "$(dirname "$DEST")"
    ln -sf "$SOURCE" "$DEST"
    echo "==> Linked VS Code settings on macOS"

# Linux / WSL
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    DEST="$HOME/.config/Code/User/settings.json"
    mkdir -p "$(dirname "$DEST")"
    ln -sf "$SOURCE" "$DEST"
    echo "==> Linked VS Code settings on Linux/WSL"
fi
