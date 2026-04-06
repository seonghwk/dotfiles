#!/bin/bash

# 1. Homebrew 설치 함수 (Linux 전용)
install_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        echo "==> Homebrew not found. Installing Homebrew..."
        
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # WSL/Linux 권한 문제 해결: /home/linuxbrew를 미리 생성하고 소유권을 현재 유저로 변경
            if [ ! -d "/home/linuxbrew" ]; then
                echo "==> Creating /home/linuxbrew with sudo (password may be required)..."
                sudo mkdir -p /home/linuxbrew
                sudo chown -R "$(whoami)" /home/linuxbrew
            fi
        fi

        # 비대화형 모드로 Homebrew 설치 (이미 디렉토리가 준비되어 권한 에러 방지)
        echo "==> Running Homebrew installer..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # 쉘 세션에 즉시 반영
        if [ -d "/home/linuxbrew/.linuxbrew" ]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
    fi
}

# 2. 메인 설치 로직
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: 이미 brew가 있을 것이므로 바로 설치
    brew install starship zoxide fzf ripgrep bat eza fd tmux nvim lazygit
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux (WSL, RPi 등): Homebrew 설치 확인 후 진행
    install_homebrew
    
    # 쉘 세션에 brew 경로 반영 (설치 직후 바로 사용하기 위함)
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    
    # 설치된 brew로 최신 도구들 설치
    brew install starship zoxide fzf ripgrep bat eza fd tmux nvim lazygit
fi
