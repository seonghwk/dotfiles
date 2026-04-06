# 🚀 Terminal-Centric Master Workflow

본 저장소는 GUI의 한계를 넘어, 오직 터미널만으로 모든 개발 업무를 완벽하게 수행하기 위한 **"터미널 마스터의 성배"** 프로젝트입니다. macOS, Windows(WSL/Native), Raspberry Pi, NAS 등 다양한 환경에서 일관되고 강력한 생산성을 유지하는 것을 목표로 합니다.

---

## 🏗️ 아키텍처 및 구조 (Architecture & Structure)

... (중략) ...

### 2. 설계 철학: 템플릿 격리 (Template Isolation)
- **Win32 에러 방지:** Windows에서는 `.sh` 파일이 생성되지 않으므로 플랫폼 충돌이 차단됩니다.
- **Single Source of Truth:** `common/` 내의 설정 파일을 각 OS의 경로에 링크하여 단일 진실 공급원을 유지합니다.

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

## ✅ 현재까지 진행된 사항 (What We've Done)

... (중략) ...

- [x] **Disaster Recovery:** `vcs`, `vcr` 기반의 환경 저장 및 복구 체계 구축.

---

## 🛠️ 설치 및 복구 방법 (Quick Start)

... (중략) ...

---

## 🚀 향후 로드맵 (Next Steps)
- [ ] **Neovim LSP 고도화:** Source Insight를 완벽 대체하는 코드 분석 환경 구축.
- [ ] **AI CLI Integration:** `Gemini CLI`, `Claude Code`를 터미널 워크플로우에 통합.
- [ ] **Embedded Automation:** WSL 내에서 Renesas CC-RX 빌드 자동화 스크립트 구현.

---

> *"Expertise is not about knowing everything, but about having the right tools and the habit of using them correctly."*
