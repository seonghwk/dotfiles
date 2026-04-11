# 🖥️ Terminal Master 연습 문제집
> chezmoi 프로젝트 기반 | tmux · fzf · rg · zoxide · bat · eza · lazygit · nvim

---

## 📌 이 문서를 보는 법
- 각 문제는 **힌트 없이 먼저 스스로 시도**하는 것이 원칙
- 막히면 힌트를 펼쳐보고, 그래도 모르면 정답을 확인
- ⭐ 개수 = 난이도 (⭐ 기초 ~ ⭐⭐⭐⭐⭐ 실전 고급)

---

## 🔷 LEVEL 1 — tmux 생존 훈련

> 목표: tmux 없이는 터미널 못 쓸 것 같은 느낌이 들 때까지

### 문제 1-1 ⭐
**상황:** 새 프로젝트를 시작한다. "myproject"라는 이름의 tmux 세션을 만들고,
화면을 왼쪽(편집)/오른쪽(실행) 두 칸으로 나눠라.
오른쪽 창은 다시 위(서버)/아래(로그) 로 나눠라.

```
[ editor ] | [ server ]
           | ---------
           | [ logs   ]
```

<details>
<summary>힌트</summary>

- `tmux new -s myproject`
- Prefix(`Ctrl-a`) + `|` 로 좌우 분할 (설정에 있음)
- Prefix + `-` 로 상하 분할
- Prefix + `hjkl` 로 이동

</details>

<details>
<summary>정답</summary>

```bash
tmux new -s myproject
# Prefix + | (좌우 분할)
# Prefix + l (오른쪽으로 이동)
# Prefix + - (상하 분할)
```

</details>

---

### 문제 1-2 ⭐⭐
**상황:** 터미널을 닫아도 작업이 유지되어야 한다.
현재 세션을 detach하고, 터미널을 완전히 닫은 후 다시 붙어라.
그리고 세션 목록을 확인하고 "myproject" 세션만 종료해라.

<details>
<summary>힌트</summary>

- `Prefix + d` → detach
- `tmux ls` → 세션 목록
- `tmux attach -t myproject` → 재연결
- `tmux kill-session -t myproject`

</details>

---

### 문제 1-3 ⭐⭐
**상황:** tmux 안에서 작업하다가 특정 커맨드의 출력을 복사해야 한다.
Copy Mode에 진입해서 마지막 20줄을 클립보드에 복사하는 과정을 연습하라.

<details>
<summary>힌트</summary>

- `Prefix + [` → Copy Mode 진입
- `G` → 맨 아래로
- `20k` → 20줄 위로
- `Space` → 선택 시작, `Enter` → 복사
- `.tmux.conf`에서 `mode-keys vi`가 설정되어 있음

</details>

---

### 문제 1-4 ⭐⭐⭐
**상황:** 개발 환경을 매번 손으로 세팅하기 귀찮다.
아래 레이아웃을 자동으로 만들어주는 쉘 스크립트 `devstart.sh`를 작성하라.

```
세션명: dev
window 1 "editor"  → nvim 실행
window 2 "server"  → 좌: 서버 실행 대기, 우: tail -f /tmp/server.log 대기
window 3 "git"     → lazygit 실행
```

<details>
<summary>정답 (완성 스크립트)</summary>

```bash
#!/bin/bash
# devstart.sh — 개발 환경 자동 세팅
SESSION="dev"

# 기존 세션이 있으면 깔끔하게 제거
tmux kill-session -t "$SESSION" 2>/dev/null

# ── Window 1: editor ──────────────────────────────
tmux new-session -d -s "$SESSION" -n "editor"
tmux send-keys -t "${SESSION}:editor" "nvim" Enter

# ── Window 2: server (좌/우 pane 분할) ────────────
tmux new-window -t "$SESSION" -n "server"
tmux split-window -h -t "${SESSION}:server"
# pane 번호: 분할 후 .0 = 왼쪽, .1 = 오른쪽
tmux send-keys -t "${SESSION}:server.0" "echo '[Server] 실행 명령어를 입력하세요'" Enter
tmux send-keys -t "${SESSION}:server.1" "touch /tmp/server.log && tail -f /tmp/server.log" Enter

# ── Window 3: git ─────────────────────────────────
tmux new-window -t "$SESSION" -n "git"
tmux send-keys -t "${SESSION}:git" "lazygit" Enter

# 시작 시 editor 창으로 포커스
tmux select-window -t "${SESSION}:editor"

# 세션에 붙기
tmux attach-session -t "$SESSION"
```

**사용법:**
```bash
chmod +x devstart.sh
./devstart.sh
```

> **핵심 포인트:**
> - pane 셀렉터는 `.left`/`.right` ❌ → `.0`/`.1` ✅ (분할 순서 기준)
> - 타겟 형식: `"${SESSION}:윈도우명.pane번호"`
> - 세션 생성 전 `kill-session`으로 충돌 방지

</details>

---

### 문제 1-5 ⭐⭐⭐
**상황:** `tmux-resurrect`가 설치되어 있다 (설정에 포함됨).
현재 모든 tmux 세션/창/레이아웃을 저장하고, 컴퓨터를 재시작한 것처럼 tmux를 kill한 뒤 복원하라.

<details>
<summary>힌트</summary>

- `Prefix + Ctrl-s` → 저장
- `Prefix + Ctrl-r` → 복원
- `tmux kill-server` 로 모두 종료 후 테스트

</details>

---

## 🔷 LEVEL 2 — fzf 퍼지 마스터

> 목표: 마우스를 거의 쓰지 않고 파일/히스토리/프로세스를 탐색

### 문제 2-1 ⭐
**상황:** 현재 디렉토리에서 `.zshrc`와 관련된 파일을 fzf로 검색해서 열어라.
(파일 내용을 bat으로 미리보면서)

```bash
# 이 명령어의 빈칸을 채워라:
fzf --preview '_____ --color=always {}' | xargs _____
```

<details>
<summary>정답</summary>

```bash
fzf --preview 'bat --color=always {}' | xargs nvim
```

</details>

---

### 문제 2-2 ⭐⭐
**상황:** `Ctrl+R`로 히스토리 검색을 해서 지난번에 실행했던 `chezmoi`가 포함된 명령어를 찾아 재실행하라.

그리고 `Ctrl+T`로 현재 디렉토리의 파일을 탐색해서 명령어에 인자로 넘겨라.

<details>
<summary>힌트</summary>

- `Ctrl+R` → fzf 히스토리 검색 (key-bindings.zsh 로 활성화됨)
- `Ctrl+T` → 파일 탐색 후 커맨드라인에 삽입
- `Alt+C` → 디렉토리 탐색 후 cd

</details>

---

### 문제 2-3 ⭐⭐
**상황:** 숨겨진 파일도 검색하고 싶다.
`.zshrc`에 설정된 `Ctrl-h` 바인딩을 활용해서 hidden 파일을 포함한 검색으로 전환하고,
`.git` 폴더 내부 파일 중 `config`를 찾아라.

<details>
<summary>힌트</summary>

- fzf 실행 후 `Ctrl-h` 를 누르면 hidden 파일 포함 모드로 전환
- `Ctrl-u` 로 다시 일반 모드로 전환
- `.zshrc`의 `FZF_DEFAULT_OPTS`에 정의되어 있음

</details>

---

### 문제 2-4 ⭐⭐⭐
**상황:** `.zshrc`에 정의된 `frg` 함수를 사용해서 `chezmoi` 프로젝트 내에서
`alias`가 정의된 모든 위치를 실시간 검색하고, 원하는 줄로 바로 nvim을 열어라.

```bash
# chezmoi 소스 디렉토리로 이동 후:
frg alias
```

<details>
<summary>힌트</summary>

- `frg`는 `rg` + `fzf` + `bat preview` + `nvim` 연동 함수
- 검색어를 바꾸면 실시간으로 결과가 갱신됨
- `Enter` 누르면 해당 줄의 nvim이 열림

</details>

---

### 문제 2-5 ⭐⭐⭐⭐
**상황:** 실행 중인 프로세스를 fzf로 선택해서 kill하는 함수 `fkill`을 만들어라.
여러 개를 선택할 수 있어야 하고, 선택 전 미리보기로 프로세스 정보를 보여줘야 한다.

<details>
<summary>힌트</summary>

```bash
fkill() {
  local pid
  pid=$(ps aux | tail -n +2 | fzf --multi --preview 'echo {}' | awk '{print $2}')
  if [ -n "$pid" ]; then
    echo "$pid" | xargs kill -9
  fi
}
```

완성하면 `.zshrc`에 추가하고 `chezmoi re-add`로 반영하라.

</details>

---

### 문제 2-6 ⭐⭐⭐⭐
**상황:** `zoxide`의 `zi` 명령어를 사용해서 자주 가는 디렉토리를 fzf 인터페이스로 이동하라.
그리고 `_ZO_FZF_OPTS`에 설정된 `eza` 미리보기가 작동하는지 확인하라.

```bash
zi   # fzf + zoxide 인터렉티브 점프
```

이후 `z 키워드` 방식으로 자주 쓰는 3개 경로를 등록해두고,
`zoxide query --list` 로 점수 순위를 확인하라.

---

## 🔷 LEVEL 3 — ripgrep 검색 전문가

> 목표: `grep` 대신 `rg`를 자유자재로 — 코드베이스를 X-ray로 보는 수준

### 문제 3-1 ⭐
**상황:** chezmoi 프로젝트에서 `alias`라는 단어가 포함된 모든 줄을 찾아라.
단, `.git` 폴더는 제외하고, 파일명과 줄 번호도 함께 출력하라.

<details>
<summary>정답</summary>

```bash
rg "alias" --line-number
# 또는 (rg는 기본으로 .git 무시)
rg -n "alias"
```

</details>

---

### 문제 3-2 ⭐⭐
**상황:** `.sh` 파일에서만 `install` 함수 정의를 찾아라.
함수 정의 패턴은 `함수명()` 또는 `function 함수명` 형식이다.

<details>
<summary>힌트</summary>

```bash
rg "^(function\s+\w+|\w+\(\))" --glob "*.sh" --glob "*.sh.tmpl"
```

</details>

---

### 문제 3-3 ⭐⭐
**상황:** 여러 머신에 배포되는 설정파일이 있다.
`dot_zshrc` 파일에서 `brew` 관련 블록(연속된 줄)을 context와 함께 찾아라.
매칭 줄 앞뒤로 3줄씩 보여줘라.

<details>
<summary>정답</summary>

```bash
rg "brew" dot_zshrc -C 3
# -A 3 (after), -B 3 (before), -C 3 (both)
```

</details>

---

### 문제 3-4 ⭐⭐⭐
**상황:** 보안 점검이 필요하다. 프로젝트 내에서 패스워드, 시크릿, API 키처럼
보이는 패턴을 찾아라. (대소문자 무관, 숨김 파일 포함)

<details>
<summary>힌트</summary>

```bash
rg -i "(password|secret|api_key|token|passwd)" --hidden --glob "!.git"
```

</details>

---

### 문제 3-5 ⭐⭐⭐
**상황:** chezmoi 템플릿 파일(`.tmpl`)에서 `{{ if` 조건문이 몇 개나 있는지 세고,
각 파일별 개수를 출력하라.

<details>
<summary>힌트</summary>

```bash
rg -c "{{ if" --glob "*.tmpl"
# -c : count per file
```

</details>

---

### 문제 3-6 ⭐⭐⭐⭐
**상황:** `dot_zshrc`에서 함수 정의 블록을 추출하고 싶다.
`frg` 함수로 실시간 검색하되, 결과를 파일로 저장하는 파이프라인을 구성하라.

```bash
# rg로 함수 블록만 뽑아서 별도 파일로
rg -A 5 "^[a-z]+\(\)" dot_zshrc > ~/notes/zsh-functions.md
```

저장 후 `bat`으로 결과를 확인하라.

---

### 문제 3-7 ⭐⭐⭐⭐⭐
**상황:** `rg`와 `fzf`를 조합해서 아래 워크플로우를 단일 명령어로 구현하라.

> "프로젝트 전체에서 특정 패턴을 검색 → fzf로 선택 → 해당 파일의 해당 줄을 nvim으로 열기"

단, `fif` 함수(이미 `.zshrc`에 있음)를 **개선**해서:
1. 멀티 선택이 가능하게 하고 (Tab으로 선택)
2. 선택된 파일들을 nvim의 arglist로 한 번에 열게 만들어라.

<details>
<summary>힌트</summary>

```bash
fif2() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string!"; return 1; fi
  local files
  files=$(rg --column --line-number --no-heading --color=always --smart-case "$1" | \
    fzf --ansi --multi \
        --delimiter : \
        --preview 'bat --color=always --highlight-line {2} {1}' | \
        awk -F: '{print $1}' | sort -u)
  [ -n "$files" ] && nvim $(echo "$files")
}
```

</details>

---

## 🔷 LEVEL 4 — chezmoi 실전 운영

> 목표: 설정 변경 → 추적 → 커밋 → 배포 사이클을 자동화

### 문제 4-1 ⭐
**상황:** 새 alias `alias df='duf'`를 `.zshrc`에 추가했다.
chezmoi로 변경사항을 감지하고 반영하라.

```bash
# 변경사항 확인
chezmoi diff
# 소스로 가져오기
chezmoi re-add ~/.zshrc
# 상태 확인
chezmoi status
```

---

### 문제 4-2 ⭐⭐
**상황:** 실수로 `~/.zshrc`를 잘못 수정했다.
chezmoi로 관리되는 버전으로 되돌려라. (실제 파일을 소스로 덮어쓰기)

<details>
<summary>힌트</summary>

```bash
chezmoi apply ~/.zshrc
# 또는 강제로:
chezmoi apply --force ~/.zshrc
```

</details>

---

### 문제 4-3 ⭐⭐⭐
**상황:** 새 머신에 환경을 세팅한다고 가정하자.
chezmoi의 `run_once_` 스크립트가 어떻게 동작하는지 이해하고,
**한 번만 실행되는 보장**이 어떻게 이루어지는지 설명하라.

그리고 이미 실행된 스크립트를 **강제로 다시 실행**시키는 방법을 찾아라.

<details>
<summary>힌트</summary>

```bash
# chezmoi가 실행 기록을 어디에 저장하는지 확인:
chezmoi doctor
ls ~/.local/share/chezmoi/

# 강제 재실행: 상태 DB에서 해당 스크립트 기록을 삭제
chezmoi state delete-bucket --bucket=scriptState
```

</details>

---

### 문제 4-4 ⭐⭐⭐⭐
**상황:** Mac과 Linux에서 다른 설정이 필요하다.
현재 `run_once_before_install-packages.sh.tmpl`에서 이미 `{{ if ne .chezmoi.os "windows" }}` 
패턴을 쓰고 있다.

이것을 응용해서 `dot_zshrc`에 **Mac에서만** 실행되는 alias 블록을 추가하라:
- Mac: `alias top='btop'`
- Linux: `alias top='htop'`

<details>
<summary>힌트</summary>

```
{{- if eq .chezmoi.os "darwin" }}
alias top='btop'
{{- else if eq .chezmoi.os "linux" }}
alias top='htop'
{{- end }}
```

단, 이를 위해 `dot_zshrc`를 `dot_zshrc.tmpl`로 변환해야 한다:
```bash
mv dot_zshrc dot_zshrc.tmpl
chezmoi apply
```

</details>

---

### 문제 4-5 ⭐⭐⭐⭐⭐
**상황:** 완전 자동화된 "Golden State 복원" 시스템을 구축하라.

`vcr` 함수가 이미 있지만, 다음을 추가로 구현하라:
1. 복원 전에 현재 상태를 `~/.zsh_history`까지 포함해서 백업
2. GitHub에서 최신 상태를 pull
3. `chezmoi apply` 실행
4. 완료 후 zsh를 reload

힌트: `exec zsh` 로 현재 쉘을 재시작할 수 있다.

---

## 🔷 LEVEL 5 — 도구 통합 실전 시나리오

> 목표: 실제 개발 워크플로우에서 모든 도구를 자연스럽게 연계

### 시나리오 5-1 ⭐⭐⭐ "버그 추적 워크플로우"
```
1. tmux에서 새 세션 "bugfix" 생성
2. 좌측 창: 코드 검색용
3. 우측 창: git 작업용 (lazygit)
4. frg로 에러 메시지 검색 → 해당 파일 nvim으로 열기
5. 수정 후 lazygit으로 커밋
6. chezmoi diff로 dotfile 변경사항 없는지 확인
```

### 시나리오 5-2 ⭐⭐⭐⭐ "환경 감사(Audit) 워크플로우"
```
1. rg로 모든 환경변수 export 구문 찾기
2. fzf로 필터링해서 수상한 것 확인
3. bat으로 해당 파일 전체 확인
4. 문제 있으면 nvim으로 수정
5. chezmoi re-add → commit → push
```

### 시나리오 5-3 ⭐⭐⭐⭐⭐ "멀티머신 설정 동기화"
```
1. 현재 머신에서 chezmoi 소스 디렉토리로 이동 (zi 사용)
2. rg로 하드코딩된 경로 찾기 (예: /Users/seonghwk)
3. chezmoi 템플릿 변수로 교체 ({{ .chezmoi.homeDir }})
4. 변경사항 diff 확인
5. lazygit으로 커밋 & 푸시
6. 새 머신에서: chezmoi init & apply 원라인으로
```

---

## 🔷 BONUS — 추가 도구 추천

현재 스택을 더욱 강화할 도구들:

| 도구 | 역할 | 설치 |
|------|------|------|
| `delta` | git diff를 아름답게 | `brew install git-delta` |
| `duf` | 디스크 사용량 (df 대체) | `brew install duf` |
| `btop` | 시스템 모니터 (top 대체) | `brew install btop` |
| `atuin` | 히스토리 동기화 (Ctrl+R 강화) | `brew install atuin` |
| `direnv` | 디렉토리별 환경변수 | `brew install direnv` |
| `jq` | JSON 파싱 | `brew install jq` |
| `yq` | YAML 파싱 | `brew install yq` |

### BONUS 문제: atuin 설치 후
atuin을 설치하고 `chezmoi re-add ~/.zshrc`로 동기화한 뒤,
Ctrl+R을 눌렀을 때 어떻게 달라지는지 확인하라.

---

## 📊 학습 체크리스트

```
[ ] tmux 세션/창/pane 자유자재로 다루기
[ ] tmux copy mode (vi 스타일)로 텍스트 복사
[ ] tmux-resurrect로 세션 저장/복원
[ ] fzf Ctrl+R, Ctrl+T, Alt+C 몸에 익히기
[ ] frg / fif 함수로 코드 탐색
[ ] rg 기본 옵션 (-n, -l, -c, -C, -A, -B, --glob) 숙달
[ ] rg + fzf 파이프라인 조합
[ ] zoxide (z, zi) 로 마우스 없이 디렉토리 탐색
[ ] chezmoi diff → re-add → commit 사이클
[ ] chezmoi 템플릿으로 OS별 분기 설정
[ ] 커스텀 zsh 함수 → chezmoi → git push 자동화
```

---

*연습 중 막히는 부분은 `chezmoi doctor`, `man fzf`, `rg --help` 를 먼저 확인하자.*
