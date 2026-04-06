#!/bin/bash

# 패키지 설치 함수
install_pkg() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install "$@"
  elif command -v brew >/dev/null 2>&1; then
    brew install "$@"
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    # Debian/Ubuntu 특화 이름 처리
    for pkg in "$@"; do
      case $pkg in
        bat) sudo apt-get install -y bat ;;
        fd) sudo apt-get install -y fd-find ;;
        nvim) sudo apt-get install -y neovim ;;
        starship) curl -sS https://starship.rs/install.sh | sh -s -- -y ;;
        eza)
          # eza는 공식 레포를 추가해야 할 수도 있으므로, 여기서는 설치 가이드 정도로 대체하거나 cargo 이용 고려
          # (간단하게 skip하거나 curl 설치 유도)
          echo "eza: Please install via official repo or cargo if needed."
          ;;
        *) sudo apt-get install -y "$pkg" ;;
      esac
    done
  fi
}

# 공통 도구 목록
CORE_TOOLS=(zoxide fzf ripgrep tmux)

# macOS 또는 Homebrew가 있는 Linux
if [[ "$OSTYPE" == "darwin"* ]] || command -v brew >/dev/null 2>&1; then
  install_pkg starship zoxide fzf ripgrep bat eza fd tmux nvim
else
  # 라즈베리파이/Debian (Homebrew 없는 경우)
  install_pkg "${CORE_TOOLS[@]}" bat fd nvim starship
fi
