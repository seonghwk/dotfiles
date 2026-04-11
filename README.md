# Terminal Master Dotfiles

`chezmoi`로 관리되는 개인 개발 환경 설정 저장소입니다.  
macOS, Linux/WSL, Windows에서 명령어 한 줄로 동일한 터미널 환경을 즉시 복구합니다.

---

## 포함된 도구

| 도구 | 역할 | 설정 파일 |
|---|---|---|
| **zsh** | 셸 + 별칭 + 고급 함수 | `dot_zshrc.tmpl` |
| **tmux** | 터미널 분할 및 세션 관리 | `dot_tmux.conf` |
| **neovim** | LSP 기반 터미널 에디터 | `private_dot_config/nvim/init.lua` |
| **starship** | 빠른 크로스셸 프롬프트 | (chezmoi가 자동 설치) |
| **fzf** | 퍼지 파인더 (대화형 검색) | `dot_zshrc.tmpl` |
| **fd** | 빠른 파일 찾기 (fzf 백엔드) | `dot_zshrc.tmpl` |
| **ripgrep** | 빠른 코드 검색 | `dot_zshrc.tmpl` |
| **bat** | 구문 강조가 있는 cat | `dot_zshrc.tmpl` |
| **eza** | 아이콘 지원 ls 대체 | `dot_zshrc.tmpl` |
| **zoxide** | 방문 빈도 기반 스마트 cd | `dot_zshrc.tmpl` |
| **lazygit** | 터미널 Git UI | `dot_zshrc.tmpl` (별칭) |

---

## 빠른 설치

### macOS / Linux / WSL

<<<<<<< Updated upstream
=======
### 📂 디렉토리 맵
- `common/`: 전 플랫폼 공용 설정 (VS Code settings, extension list 등)
- `dot_zshrc`: Zsh 환경 (Mac/Linux/WSL) - 전용 Alias 및 fzf 고도화 로직 포함
- `dot_tmux.conf`: 터미널 멀티플렉서 (Prefix: `C-a`, Vim-like pane 이동)
- `private_dot_config/nvim/`: Neovim IDE 설정 (Lazy.nvim, Treesitter, LSP 기반)
- `Documents/PowerShell/`: Windows Native용 프로필 및 전용 함수
- `Documents/terminal-exercises.md`: tmux·fzf·rg·chezmoi 실전 연습 문제집 (5 레벨)
- `run_once_before_...`: [OS 격리] 플랫폼별 패키지(brew/apt/choco) 자동 설치 스크립트
- `run_once_after_...`: [OS 격리] 플러그인 설치 및 설정 심볼릭 링크 생성 로직

---

## ✨ 핵심 기능 (Key Features)

### 1. 지능형 탐색 및 고급 검색 (Smart Navigation & Advanced Search)
- **fzf + fd:** `CTRL-T` 또는 `**[Tab]` 입력 시 일반 파일만 깔끔하게 검색.
- **Dynamic Toggle:** 검색창에서 `CTRL-H`를 누르면 숨김 파일 포함, `CTRL-U`를 누르면 다시 일반 모드로 즉시 전환.
- **frg (Interactive Ripgrep):** 실시간 검색을 통해 특정 코드 라인으로 즉시 점프.
- **fif (Find In Files):** 특정 키워드가 포함된 모든 파일 목록을 탐색.

### 2. IDE & Editor 통합
- **VS Code Sync:** `common/vscode-settings.json` 하나로 모든 OS의 설정 통제.
- **Neovim Mastery:** 터미널 내에서 LSP 기반 코드 분석 및 `jk` 단축키를 통한 고속 편집 모드 전환.
- **Vim Mode Unity:** Neovim과 VS Code 모두에서 동일한 Vim 맵핑과 감각 유지.

### 3. 안정성 및 복구 (Disaster Recovery)
- **`vcs` (VS Code Save):** 현재의 설정을 저장소에 백업하고 GitHub에 즉시 푸시.
- **`vcr` (VS Code Revert):** 로컬의 잘못된 설정을 파기하고 GitHub의 '골든 스테이트'로 강제 복구.
- **`fkill` (Fuzzy Kill):** `fzf` 인터페이스로 실행 중인 프로세스를 선택해서 종료.

---

## 🛠️ 퀵 스타트 (Quick Start)

### 🍏 macOS / 🐧 Linux / 💻 WSL
>>>>>>> Stashed changes
```bash
# Linux/WSL 전용: Homebrew 설치 경로 권한 확보
sudo mkdir -p /home/linuxbrew && sudo chown -R $(whoami) /home/linuxbrew

# chezmoi가 없다면 아래 한 줄로 설치 + 환경 구성을 동시에 실행합니다.
# 패키지 설치(brew/apt) → 플러그인 설정 → 설정 파일 심볼릭 링크 생성이 자동으로 이루어집니다.
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply seonghwk
```

### Windows (관리자 권한 PowerShell)

```powershell
# winget으로 chezmoi 설치 후, Chocolatey 패키지 설치 + 환경 구성을 자동으로 실행합니다.
winget install chezmoi
chezmoi init --apply seonghwk
```

---

## 일상적인 사용법

### 1. 파일 탐색

| 명령 | 설명 |
|---|---|
| `z <이름 일부>` | 자주 방문한 디렉토리로 즉시 이동 |
| `zi` | 방문 기록을 fzf로 검색 + eza 트리 미리보기 |
| `CTRL-T` | 현재 디렉토리 아래 파일을 퍼지 검색하여 선택 |
| `vi **<Tab>` | vim 명령에 파일명 퍼지 완성 |

fzf 검색창 안에서:
- `CTRL-H` → 숨김 파일 포함 모드로 전환
- `CTRL-U` → 일반 파일만 보는 모드로 복귀

### 2. 코드 검색

```bash
# frg: 입력할 때마다 실시간으로 ripgrep 검색, Enter로 해당 줄의 neovim으로 바로 점프
frg <검색어>

# fif: 특정 키워드가 포함된 파일 목록 탐색, Enter로 해당 줄 열기
fif <검색어>
```

### 3. tmux 워크플로우

**Prefix 키는 `Ctrl-a`입니다.**

| 단축키 | 동작 |
|---|---|
| `Prefix + \|` | 화면을 세로로 분할 |
| `Prefix + -` | 화면을 가로로 분할 |
| `Prefix + h/j/k/l` | 분할 창 간 이동 (vim 방향키) |
| `Prefix + H/J/K/L` | 창 크기 조절 (반복 입력 가능) |
| `Prefix + [` | 복사 모드 진입 (hjkl 이동, Space 선택 시작, Enter 복사) |
| `Prefix + r` | 설정 파일 즉시 리로드 |
| `Prefix + Ctrl-s` | 현재 세션 저장 (tmux-resurrect) |
| `Prefix + Ctrl-r` | 저장된 세션 복구 (tmux-resurrect) |

### 4. Neovim 단축키

**Leader 키는 `Space`입니다.**

| 단축키 | 동작 |
|---|---|
| `jk` | 입력 모드 → 일반 모드 전환 |
| `Space + e` | 파일 탐색기 토글 (NvimTree) |
| `Space + ff` | 파일 이름으로 찾기 (Telescope) |
| `Space + fg` | 파일 내용으로 찾기 (Telescope live grep) |
| `:Lazy` | 플러그인 관리자 열기 |
| `:Mason` | LSP 서버 설치/관리 |

### 5. VS Code 설정 동기화

```bash
# vcs (VS Code Save): 현재 설정을 저장소에 백업하고 GitHub에 푸시
# macOS와 Linux/WSL 모두 지원합니다.
vcs

# vcr (VS Code Revert): GitHub의 최신 상태로 강제 복구
# 로컬 설정이 꼬였을 때 사용합니다.
vcr
```

---

## 저장소 구조

```
chezmoi 소스 루트/
├── common/                      # 모든 플랫폼이 공유하는 파일
│   ├── vscode-settings.json     # VS Code 설정 (chezmoi apply 시 심볼릭 링크 생성)
│   └── vscode-extensions.txt   # 확장 목록 (chezmoi apply 시 자동 설치)
├── dot_zshrc.tmpl               # Zsh 설정 (macOS, Linux, WSL) — chezmoi 템플릿
├── dot_tmux.conf                # tmux 설정
├── private_dot_config/nvim/     # Neovim 설정 (Lazy.nvim 기반)
├── Documents/PowerShell/        # Windows PowerShell 프로필
└── run_once_* / run_onchange_*  # chezmoi 자동 실행 스크립트 (OS별 분기 처리)
```

> `dot_zshrc.tmpl`은 chezmoi의 Go 템플릿으로, `chezmoi apply` 시점에 OS별로 적절한 경로를 파일에 직접 기록합니다 (예: macOS는 `~/Library/...`, Linux는 `~/.config/...`).

---

## 설정 변경 후 동기화

로컬에서 설정 파일을 수정한 경우:

```bash
# 변경 사항을 chezmoi 소스 트리에 반영
chezmoi add ~/.zshrc
chezmoi add ~/.tmux.conf

# 변경 사항 커밋 및 푸시 (또는 vcs 명령 사용)
chezmoi cd
git add . && git commit -m "chore: update config" && git push

# 다른 기기에서 최신 상태 적용
chezmoi update
```
=======
> *Crafting the future of terminal mastery.*
