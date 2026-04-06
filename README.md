# 🚀 Terminal-Centric Master Workflow

본 저장소는 GUI의 한계를 넘어, 오직 터미널만으로 모든 개발 업무를 완벽하게 수행하기 위한 **"터미널 마스터의 성배"** 프로젝트입니다. macOS, Windows(WSL/Native), Raspberry Pi, NAS 등 다양한 환경에서 일관되고 강력한 생산성을 유지하는 것을 목표로 합니다.

---

## 🎯 프로젝트의 목표 (The Goal)
- **Zero-GUI Workflow:** 마우스 없이 키보드만으로 모든 조작을 수행하는 환경 구축.
- **Single Source of Truth:** 모든 설정(Terminal, Editor, IDE)을 `chezmoi`와 Git으로 중앙 통제.
- **Cross-Platform Portability:** 어떤 OS에서도 5분 안에 동일한 환경(VS Code 포함) 복구.
- **Thinking in Typing:** 모든 제어권을 타이핑으로 수행하여 "손가락으로 생각하는 개발" 지향.

---

## 🏗️ 아키텍처 및 구조 (Architecture & Structure)

본 프로젝트는 **`chezmoi`**의 지능형 템플릿 기능을 활용하여, 서로 다른 4개의 OS 환경(Mac, WSL, RPi, Windows)을 단 하나의 저장소로 완벽하게 통제합니다.

### 1. 디렉토리 구조 (Directory Map)
```text
dotfiles/
├── common/                # [Universal] 모든 OS에서 공유하는 앱 설정 (VS Code settings/extensions)
├── dot_zshrc              # [Static] 쉘 환경 설정 및 마스터 Alias (vcs, vcr 등)
├── dot_tmux.conf          # [Static] 터미널 멀티플렉서 설정
├── private_dot_config/    # [App-Specific] Neovim 등 상세 앱 설정
│   └── nvim/init.lua
├── run_once_before_...    # [Bootstrap] 패키지 자동 설치 로직
│   ├── .sh.tmpl           #  -> macOS / Linux 전용 (brew/apt)
│   └── .ps1.tmpl          #  -> Windows Native 전용 (choco)
└── run_once_after_...     # [Post-Install] 플러그인 설치 및 심볼릭 링크 생성
    ├── .sh.tmpl           #  -> macOS / Linux 전용
    └── .ps1.tmpl          #  -> Windows Native 전용
```

### 2. 설계 철학: 템플릿 격리 (Template Isolation)
모든 실행 스크립트(`.sh`, `.ps1`)는 **`.tmpl`** 확장자를 통해 관리됩니다. 이는 `chezmoi`가 실행 시점에 대상 OS를 감지하여 **해당 OS에 맞는 스크립트만 생성하고 실행**하게 합니다.
- **Win32 에러 방지:** Windows에서는 유닉스용 `.sh` 파일이 생성조차 되지 않으므로, 플랫폼 충돌로 인한 에러가 원천 차단됩니다.
- **Single Source of Truth:** `common/` 내의 설정 파일을 각 OS의 경로에 심볼릭 링크(또는 하드링크)로 연결하여, 단 하나의 파일 수정으로 모든 플랫폼의 IDE 설정을 동기화합니다.

---

## 🛡️ 안정성 및 복구 매뉴얼 (Stability & Recovery)

본 프로젝트는 **"언제든 1초 만에 최상의 상태로 복구 가능함"**을 전제로 설계되었습니다.

### 1. VS Code Profile: 설정 샌드박스 (Sandbox)
- **Default Profile:** `chezmoi`가 관리하는 **"Golden State"**입니다. 업무 및 핵심 개발에 사용합니다.
- **Custom Profiles:** 새로운 실험이나 특정 언어 테스트를 위한 **Sandbox**로 활용하세요. 다른 프로필에서의 변경은 Default 설정에 영향을 주지 않습니다.

### 2. 저장 및 복구 워크플로우 (Save & Revert)
터미널에서 제공되는 전용 별칭(Alias)을 통해 환경을 관리합니다.

- **`vcs` (VS Code Save):**
  - 현재 설치된 익스텐션 목록과 설정을 저장소에 백업하고 GitHub에 즉시 푸시합니다.
  - *사용 시점:* 새로운 도구가 마음에 들어 내 환경의 표준으로 삼고 싶을 때.

- **`vcr` (VS Code Revert):**
  - 로컬의 모든 임시 변경 사항을 파기하고 GitHub의 최신 상태로 강제 복구합니다.
  - *사용 시점:* 실험 중 설정이 꼬였거나, 이전의 안정적인 상태로 돌아가고 싶을 때.

### 3. 강제 초기화 (Hard Reset)
로컬 환경이 회생 불가능할 정도로 망가졌을 때:
```bash
# 로컬 저장소 강제 초기화 및 GitHub 최신본 적용
chezmoi cd
git fetch origin main && git reset --hard origin/main
cd -
chezmoi apply --force
```

---

## 🎓 터미널 마스터 마스터리 로드맵 (Mastery Roadmap)

터미널 마스터로 등극하기 위해 아래 우선순위에 따라 도구의 사용법을 익히는 것을 권장합니다.

### 1️⃣ Rank 1: Tmux (공간 제어 - 공간의 주인)
- **핵심:** 세션 유지 및 화면 분할. 터미널 하나를 무한한 작업 공간으로 확장합니다.
- **마스터 포인트:** 세션 분리(Detach) 후 재접속, 윈도우 생성/이동, 패널 분할 및 레이아웃 전환.

### 2️⃣ Rank 2: Neovim (편집 제어 - 생산의 심장)
- **핵심:** Vim 모션을 통한 "생각의 속도"로 코딩. 단순 에디터를 넘어선 개인화된 IDE 구축.
- **마스터 포인트:** 기본 모션(hjkl, w, b, f), LSP 기반 코드 분석(Go to Definition), 플러그인 관리.

### 3️⃣ Rank 3: fzf (탐색 제어 - 검색의 혁명)
- **핵심:** 퍼지 서치를 통한 모든 리소스의 즉각적 탐색.
- **마스터 포인트:** 파일 찾기(`CTRL-T`), 히스토리 서치(`CTRL-R`), 디렉토리 이동(`ALT-C`) 생활화.

### 4️⃣ Rank 4: ripgrep (검색 제어 - 전지적 시점)
- **핵심:** 수백만 줄의 코드 베이스를 0.1초 만에 훑어내는 초고속 검색 엔진.
- **마스터 포인트:** 대소문자 구분 검색, 정규식 활용, 특정 파일 확장자 필터링 검색.

### 5️⃣ Rank 5: Modern Utilities (가속기 - 현대적 편의)
- **zoxide (`z`):** 기억이 아닌 습관으로 이동하는 지능형 `cd`.
- **bat / eza:** 가독성 높은 파일 확인과 아이콘 기반의 미려한 디렉토리 목록 조회.

---

## ✅ 현재까지 진행된 사항 (What We've Done)

### 1. 기반 인프라 구축
- [x] **Multi-Platform Sync:** `chezmoi` 템플릿을 통한 Mac/WSL/RPi/Windows 통합 관리 체계.
- [x] **Smart Installation:** OS 및 패키지 매니저별 자동 설치 스크립트 격리 구현.
- [x] **Homebrew on Linux:** 저사양 RPi 및 WSL에서 최신 도구를 사용하기 위한 환경 최적화.

### 2. 핵심 도구 설정 (The Golden Stack)
- [x] **Shell (Zsh):** Starship, zoxide, fzf 기반의 스마트 네비게이션 및 마스터 Alias 구축.
- [x] **Multiplexer (Tmux):** 전문가용 분할 레이아웃 및 세션 유지 (Prefix: `Ctrl-a`).
- [x] **Editor (Neovim):** `Lazy.nvim` 기반의 모던 플러그인 체계 및 Catppuccin 테마.

### 3. IDE 통합 (VS Code Master)
- [x] **Universal Sync:** `common/vscode-settings.json` 하나로 전 OS IDE 설정 통합.
- [x] **Extension Management:** 설치된 익스텐션을 `vscode-extensions.txt` 리스트 기반으로 자동 관리.
- [x] **Disaster Recovery:** `vcs`, `vcr` 기반의 환경 저장 및 복구 체계 구축.

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

---

> *"Expertise is not about knowing everything, but about having the right tools and the habit of using them correctly."*
