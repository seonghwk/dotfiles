# 🚀 Terminal-Centric Master Workflow

본 저장소는 GUI의 한계를 넘어, 오직 터미널만으로 모든 개발 업무를 완벽하게 수행하기 위한 **"터미널 마스터의 성배"** 프로젝트입니다. macOS, Windows(WSL/Native), Raspberry Pi, NAS 등 다양한 환경에서 일관되고 강력한 생산성을 유지하는 것을 목표로 합니다.

---

## 🏗️ 아키텍처 및 구조 (Architecture & Structure)

본 프로젝트는 **`chezmoi`**의 지능형 템플릿 기능을 활용하여, 서로 다른 4개의 OS 환경(Mac, WSL, RPi, Windows)을 단 하나의 저장소로 완벽하게 통제합니다.

### 1. 디렉토리 구조 (Directory Map)
```text
dotfiles/
├── common/                # [Universal] 모든 OS에서 공유하는 앱 설정 (예: VS Code)
├── dot_zshrc              # [Static] 쉘 환경 설정
├── dot_tmux.conf          # [Static] 터미널 멀티플렉서 설정
├── private_dot_config/    # [App-Specific] Neovim 등 상세 앱 설정
│   └── nvim/init.lua
├── run_once_before_...    # [Bootstrap] 패키지 자동 설치 로직
│   ├── .sh.tmpl           #  -> macOS / Linux 전용 (brew/apt)
│   └── .ps1.tmpl          #  -> Windows Native 전용 (choco)
└── run_once_after_...     # [Post-Install] 플러그인 설치 및 심볼릭 링크 생성
```

### 2. 설계 철학: 템플릿 격리 (Template Isolation)
모든 실행 스크립트(`.sh`, `.ps1`)는 **`.tmpl`** 확장자를 통해 관리됩니다. 이는 `chezmoi`가 실행 시점에 대상 OS를 감지하여 **해당 OS에 맞는 스크립트만 생성하고 실행**하게 합니다.
- **Win32 에러 방지:** Windows에서는 `.sh` 파일이 생성조차 되지 않으므로, 유닉스용 스크립트 실행 시도로 인한 에러가 원천 차단됩니다.
- **Single Source of Truth:** `common/` 내의 설정 파일을 각 OS의 경로에 심볼릭 링크(또는 하드링크)로 연결하여, 단 하나의 파일 수정으로 모든 플랫폼의 IDE 설정을 동기화합니다.

---

## ✅ 현재까지 진행된 사항 (What We've Done)

### 1. 기반 인프라 구축
- [x] **Multi-Platform Sync:** `chezmoi` 템플릿을 통한 Mac/WSL/RPi/Windows 통합 관리 체계.
- [x] **Smart Installation:** OS 및 패키지 매니저별 자동 설치 스크립트 격리 구현.
- [x] **Homebrew on Linux:** 저사양 RPi 및 WSL에서 최신 도구를 사용하기 위한 환경 최적화.

### 2. 핵심 도구 설정 (The Golden Stack)
- [x] **Shell (Zsh):** Starship, zoxide, fzf 기반의 스마트 네비게이션.
- [x] **Multiplexer (Tmux):** 전문가용 분할 레이아웃 및 세션 유지 (Prefix: `Ctrl-a`).
- [x] **Editor (Neovim):** `Lazy.nvim` 기반의 모던 플러그인 체계 및 Catppuccin 테마.

### 3. IDE 통합 (VS Code Master)
- [x] **Universal Sync:** `common/vscode-settings.json` 하나로 전 OS IDE 설정 통합.
- [x] **Native Support:** Windows PowerShell 전용 동기화 스크립트(`ps1.tmpl`) 구축.

---

## 🛠️ 설치 및 복구 방법 (Quick Start)

### 🍏 macOS / 🐧 Linux / 💻 WSL
```bash
# 1. (WSL/Linux인 경우) Homebrew 표준 경로 선점 (단 한 번만 수행)
sudo mkdir -p /home/linuxbrew && sudo chown -R $(whoami) /home/linuxbrew

# 2. chezmoi를 통한 전체 설정 적용 및 도구 자동 설치
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply seonghwk
```

### 🪟 Windows (Native PowerShell)
```powershell
# 1. chezmoi 설치 (관리자 권한 PowerShell)
winget install chezmoi  # 또는 choco install chezmoi

# 2. 설정 적용
chezmoi init --apply seonghwk
```

---

## 🚀 향후 로드맵 (Next Steps)
- [ ] **Neovim LSP 고도화:** Source Insight를 완벽 대체하는 코드 분석 환경 구축.
- [ ] **AI CLI Integration:** `Gemini CLI`, `Claude Code`를 터미널 워크플로우에 통합.
- [ ] **Embedded Automation:** WSL 내에서 Renesas CC-RX 빌드 자동화 스크립트 구현.
