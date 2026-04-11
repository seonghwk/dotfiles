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
├── Documents/terminal-exercises.md  # tmux·fzf·rg·chezmoi 실전 연습 문제집
└── run_once_* / run_onchange_*  # chezmoi 자동 실행 스크립트 (OS별 분기 처리)
```

> `dot_zshrc.tmpl`은 chezmoi의 Go 템플릿으로, `chezmoi apply` 시점에 OS별로 적절한 경로를 파일에 직접 기록합니다.

---

## 일상적인 사용법

### 1. 파일 탐색 (zsh + fzf + zoxide)

| 명령 | 설명 |
|---|---|
| `z <이름 일부>` | 자주 방문한 디렉토리로 즉시 이동 |
| `zi` | 방문 기록을 fzf로 검색 + eza 트리 미리보기 |
| `CTRL-T` | 현재 디렉토리 아래 파일을 퍼지 검색하여 선택 |
| `vi **<Tab>` | vim 명령에 파일명 퍼지 완성 |

fzf 검색창 안에서:
- `CTRL-H` → 숨김 파일 포함 모드로 전환
- `CTRL-U` → 일반 파일만 보는 모드로 복귀

### 2. 코드 검색 (zsh 함수)

```bash
# frg: 입력할 때마다 실시간으로 ripgrep 검색, Enter로 해당 줄의 neovim으로 바로 점프
frg <검색어>

# fif: 특정 키워드가 포함된 파일 목록 탐색, Enter로 해당 줄 열기
fif <검색어>

# fkill: fzf로 실행 중인 프로세스를 선택해서 종료
fkill
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

### 4. Neovim

**Leader 키는 `Space`입니다.**

#### 4-1. 파일 탐색

| 단축키 | 동작 |
|---|---|
| `Space + e` | 파일 탐색기 열기/닫기 (NvimTree) |
| `Space + E` | 현재 파일을 탐색기에서 강조 표시 |
| `Space + ff` | 파일 이름으로 검색 (Telescope) |
| `Space + fr` | 최근 열었던 파일 목록 (Telescope) |
| `Space + fb` | 열려 있는 버퍼 목록 (Telescope) |
| `Shift + l / h` | 다음 / 이전 버퍼로 이동 |
| `Space + bd` | 현재 버퍼 닫기 |

#### 4-2. 코드 검색 및 분석

| 단축키 | 동작 |
|---|---|
| `Space + fg` | 전체 파일 내용 실시간 검색 (live grep) |
| `Space + fs` | 현재 파일의 함수·클래스 심볼 검색 |
| `Space + fS` | 프로젝트 전체 심볼 검색 |
| `Space + fd` | 현재 진단(에러/경고) 목록 검색 |
| `Space + oo` | 코드 구조 아웃라인 열기/닫기 (Aerial) |
| `Space + on / op` | 아웃라인에서 다음 / 이전 심볼로 이동 |

#### 4-3. LSP (언어 서버)

| 단축키 | 동작 |
|---|---|
| `gd` | 정의로 이동 (Go to Definition) |
| `gD` | 선언으로 이동 (Go to Declaration) |
| `gr` | 참조 목록 (Find References) |
| `gi` | 구현으로 이동 (Go to Implementation) |
| `K` | 커서 아래 심볼의 문서 보기 (Hover) |
| `Space + rn` | 심볼 이름 일괄 변경 (Rename) |
| `Space + ca` | 코드 액션 (자동 수정 제안) |
| `[d / ]d` | 이전 / 다음 진단으로 이동 |
| `Space + d` | 현재 줄 진단 메시지 팝업 |

> **자동 설치되는 LSP 서버:** `lua_ls`, `pyright` (Python), `ts_ls` (TypeScript/JS), `bashls`, `jsonls`, `yamlls`, `html`, `cssls`  
> `:Mason` 으로 설치 현황 확인 및 추가 서버 설치 가능.

#### 4-4. 진단 패널 (Trouble)

| 단축키 | 동작 |
|---|---|
| `Space + xx` | 프로젝트 전체 에러/경고 패널 토글 |
| `Space + xd` | 현재 파일의 에러/경고 패널 토글 |
| `Space + xl` | Location list 토글 |
| `Space + xq` | Quickfix list 토글 |

#### 4-5. Git 연동 (Gitsigns)

| 단축키 | 동작 |
|---|---|
| `]c / [c` | 다음 / 이전 변경 hunk로 이동 |
| `Space + hs` | 현재 hunk 스테이징 |
| `Space + hr` | 현재 hunk 되돌리기 |
| `Space + hb` | 현재 줄 git blame 표시 |
| `Space + hd` | 현재 파일 diff 보기 |
| `Space + gg` | Lazygit 터미널 열기 |

#### 4-6. 편집 보조

| 단축키 | 동작 |
|---|---|
| `jk` | 입력 모드 → 일반 모드 전환 |
| `gcc` | 현재 줄 주석 토글 |
| `gc + 모션` | 범위 주석 토글 (예: `gc5j` → 아래 5줄) |
| `ys + 모션 + 문자` | 텍스트를 문자로 감싸기 (예: `ysiw"` → 단어를 `""`로) |
| `ds + 문자` | 감싸는 문자 제거 (예: `ds"`) |
| `cs + 이전 + 새` | 감싸는 문자 교체 (예: `cs"'`) |
| `Space + fm` | 현재 파일 포맷 (저장 시 자동 실행) |
| `Ctrl + \` | 터미널 패널 열기/닫기 |
| `Ctrl + h/j/k/l` | 창 간 이동 |

#### 4-7. 자동완성 (nvim-cmp)

| 키 | 동작 |
|---|---|
| `Ctrl-Space` | 자동완성 수동 트리거 |
| `Ctrl-n / Ctrl-p` | 다음 / 이전 항목 선택 |
| `Tab / Shift-Tab` | 다음 / 이전 항목 선택 또는 스니펫 이동 |
| `Enter` | 선택 확정 |
| `Ctrl-e` | 자동완성 닫기 |

#### 4-8. 플러그인 관리

| 명령 | 동작 |
|---|---|
| `:Lazy` | 플러그인 관리자 (설치/업데이트/삭제) |
| `:Mason` | LSP 서버 설치/관리 |
| `:TSUpdate` | Treesitter 파서 업데이트 |

### 5. VS Code 설정 동기화

```bash
# vcs (VS Code Save): 현재 설정을 저장소에 백업하고 GitHub에 푸시
vcs

# vcr (VS Code Revert): GitHub의 최신 상태로 강제 복구
vcr
```

---

## 설정 변경 후 동기화

로컬에서 설정 파일을 수정한 경우:

```bash
# 변경 사항을 chezmoi 소스 트리에 반영
chezmoi add ~/.config/nvim/init.lua
chezmoi add ~/.tmux.conf

# 변경 사항 커밋 및 푸시 (또는 vcs 명령 사용)
chezmoi cd
git add . && git commit -m "chore: update config" && git push

# 다른 기기에서 최신 상태 적용
chezmoi update
```
