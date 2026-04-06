# 🚀 Terminal-Centric Master Workflow

본 저장소는 GUI의 한계를 넘어, 오직 터미널만으로 모든 개발 업무를 완벽하게 수행하기 위한 **"터미널 마스터의 성배"** 프로젝트입니다. macOS, Windows(WSL/Native), Raspberry Pi, NAS 등 다양한 환경에서 일관되고 강력한 생산성을 유지하는 것을 목표로 합니다.

---

## 🎯 프로젝트의 목표 (The Goal)
- **Zero-GUI Workflow:** 마우스 없이 키보드만으로 모든 조작을 수행하는 환경 구축.
- **Single Source of Truth:** 모든 설정(Terminal, Editor, IDE)을 `chezmoi`와 Git으로 중앙 통제.
- **Cross-Platform Portability:** 어떤 OS에서도 5분 안에 동일한 환경(VS Code 포함) 복구.
- **Thinking in Typing:** 모든 제어권을 타이핑으로 수행하여 "손가락으로 생각하는 개발" 지향.

---

## ✅ 현재까지 진행된 사항 (What We've Done)

### 1. 기반 인프라 구축
- [x] **Dotfiles Management:** `chezmoi`를 도입하여 설정 파일의 중앙 관리 및 동기화 체계 마련.
- [x] **Smart Installation:** OS 및 패키지 매니저를 감지하여 도구를 자동 설치하는 지능형 스크립트 작성.
- [x] **Homebrew on Linux:** WSL 및 라즈베리파이에서 최신 도구(Neovim 0.10+ 등)를 사용하기 위한 환경 구축.

### 2. 핵심 도구 설정 (The Golden Stack)
- [x] **Shell (Zsh/PowerShell):** Starship 프롬프트, zoxide, fzf 연동으로 스마트한 네비게이션 구현.
- [x] **Multiplexer (Tmux):** 세션 유지 및 화면 분할을 위한 전문가용 설정 (Prefix: `Ctrl-a`).
- [x] **Editor (Neovim):** `Lazy.nvim` 기반의 모던한 플러그인 관리 체계 및 기본 테마(Catppuccin) 적용.

### 3. IDE 통합 (VS Code Master Strategy)
- [x] **Start from Scratch:** 기존 설정을 완전히 초기화하고 `chezmoi` 기반의 관리 체계로 전환.
- [x] **Universal Sync:** 단 하나의 `common/vscode-settings.json`을 사용하여 Mac/Linux/WSL/Windows의 설정을 완벽 동기화.
- [x] **Native Support:** Windows 환경을 위한 PowerShell 전용 동기화 스크립트(`run_onchange_...ps1`) 구축.
- [x] **Automated Extensions:** 필수 확장 프로그램(`vscodevim`, `python`, `jupyter`, `cpptools` 등) 자동 설치 체계 구축.

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

# 2. 설정 적용 (PATH 인식이 안 될 경우 터미널 재시작 후 실행)
chezmoi init --apply seonghwk
```
*Tip: Windows에서 명령어가 인식되지 않으면 `$env:Path` 환경 변수에 `C:\ProgramData\chocolatey\bin` 또는 설치 경로가 포함되어 있는지 확인하세요.*

---

## 🚀 향후 로드맵 (Next Steps & Goals)

### 1단계: Neovim을 진정한 IDE로 (LSP & Treesitter)
- [ ] **LSP(Language Server Protocol):** 코드 자동 완성, 정의 이동, 실시간 에러 체크 활성화.
- [ ] **Telescope:** 파일 및 텍스트 검색을 위한 퍼지 파인더 고도화.
- [ ] **Call Hierarchy:** Source Insight를 대체하는 강력한 코드 분석 기능 구현.

### 2단계: AI & 임베디드 워크플로우
- [ ] **AI Integration:** `Gemini CLI`, `Claude Code` 및 `Ollama` 원격 서버를 터미널 워크플로우에 통합.
- [ ] **Embedded Build:** WSL 내에서 Renesas CC-RX Windows 컴파일러를 호출하는 빌드 자동화 스크립트 작성.

---

> *"Expertise is not about knowing everything, but about having the right tools and the habit of using them correctly."*
