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

# Windows (Git Bash, MSYS 등 Bash 환경에서 실행 시)
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    # APPDATA 경로 확보 (Windows 표준)
    APPDATA_PATH=$(powershell.exe -NoProfile -Command "Write-Host \$env:APPDATA" | tr -d '\r')
    DEST="$APPDATA_PATH/Code/User/settings.json"
    mkdir -p "$(dirname "$DEST")"
    # Windows에서는 심볼릭 링크 생성이 권한 문제로 어려울 수 있으므로 하드링크 또는 복사 권장
    cp -f "$SOURCE" "$DEST"
    echo "==> Copied VS Code settings on Windows"
fi
