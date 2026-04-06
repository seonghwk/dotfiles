# 🚀 Terminal-Centric Master Workflow

본 저장소는 GUI의 한계를 넘어, 오직 터미널만으로 모든 개발 업무를 완벽하게 수행하기 위한 **"터미널 마스터의 성배"** 프로젝트입니다. macOS, Windows(WSL), Raspberry Pi, NAS 등 다양한 환경에서 일관되고 강력한 생산성을 유지하는 것을 목표로 합니다.

---

## 🎯 프로젝트의 목표 (The Goal)
- **Zero-GUI Workflow:** 마우스 없이 키보드만으로 모든 조작을 수행하는 환경 구축.
- **Cross-Platform Portability:** `chezmoi`와 `Homebrew`를 활용하여 어떤 OS에서도 5분 안에 동일한 환경 복구.
- **Modern & Fast:** Rust/Go 기반의 최신 도구들을 사용하여 압축적인 속도와 가벼운 성능 확보.
- **Traceable Changes:** 모든 설정 변화를 Git으로 기록하여 나의 성장 궤적을 관리.

---

## ✅ 현재까지 진행된 사항 (What We've Done)

### 1. 기반 인프라 구축
- [x] **Dotfiles Management:** `chezmoi`를 도입하여 설정 파일의 중앙 관리 및 동기화 체계 마련.
- [x] **Smart Installation:** `run_once_before_install-packages.sh` 스크립트를 통해 OS별 패키지 자동 설치 자동화.
- [x] **Homebrew on Linux:** WSL 및 라즈베리파이에서 최신 도구를 사용하기 위한 Homebrew 환경 구축.

### 2. 핵심 도구 설정 (The Golden Stack)
- [x] **Shell (Zsh):** Starship 프롬프트와 zoxide, fzf 연동으로 스마트한 네비게이션 구현.
- [x] **Multiplexer (Tmux):** 세션 유지 및 화면 분할을 위한 전문가용 `.tmux.conf` 설정 (Prefix: `Ctrl-a`).
- [x] **Editor (Neovim):** `Lazy.nvim` 기반의 모던한 플러그인 관리 체계 및 기본 테마(Catppuccin) 적용.

### 3. 주요 자동화 스크립트
- [x] Mac/Linux/WSL/RPi 통합 설치 스크립트 작성.
- [x] WSL 권한 문제 해결을 위한 Homebrew 표준 경로 대응 로직.

---

## 🛠️ 설치 및 복구 방법 (Quick Start)

새로운 환경에서 아래 명령어 한 줄이면 모든 세팅이 완료됩니다:

```bash
# 1. (WSL/Linux인 경우) Homebrew 표준 경로 선점 (단 한 번만 수행)
sudo mkdir -p /home/linuxbrew && sudo chown -R $(whoami) /home/linuxbrew

# 2. chezmoi를 통한 전체 설정 적용 및 도구 자동 설치
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply seonghwk
```

---

## 🚀 향후 로드맵 (Next Steps & Goals)

### 1단계: Neovim을 진정한 IDE로 (LSP & Treesitter)
- [ ] **LSP(Language Server Protocol):** 코드 자동 완성, 정의 이동, 실시간 에러 체크 활성화.
- [ ] **Treesitter:** 정교한 구문 강조를 통한 코드 가독성 극대화.
- [ ] **Telescope:** 파일 및 텍스트 검색을 위한 퍼지 파인더 고도화.

### 2단계: 워크플로우 통합
- [ ] **LazyGit:** 터미널 기반의 시각적 Git 관리 도구 숙달.
- [ ] **Yazi:** Rust 기반의 초고속 터미널 파일 매니저 도입 및 습관화.

### 3단계: 머슬 메모리 (Muscle Memory)
- [ ] Vim Motions (`hjkl`, Text Objects) 체화.
- [ ] Tmux 창 관리 및 세션 전환 단축키 숙달.

---

> *"Expertise is not about knowing everything, but about having the right tools and the habit of using them correctly."*
