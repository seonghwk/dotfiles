#!/bin/bash
# macOS인 경우 brew로 설치
if [[ "$OSTYPE" == "darwin"* ]]; then
   brew install starship zoxide fzf ripgrep bat eza fd tmux nvim
# Linux/WSL인 경우 (Homebrew가 설치되어 있다고 가정)
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
   brew install starship zoxide fzf ripgrep bat eza fd tmux nvim
fi
