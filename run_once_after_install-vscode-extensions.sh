 Code가 설치되어 있을 때만 실행
if command -v code >/dev/null 2>&1; then
    echo "==> Installing VS Code Extensions..."

    EXTENSIONS=(
        vscodevim.vim               # Vim 모드
        ms-python.python            # 파이썬 기본
    ms-toolsai.jupyter          # 주피터 노트북
    ms-vscode.cpptools          # C/C++ (Renesas 대응)
    catppuccin.catppuccin-vsc   # 테마 (우리 터미널 테마와 통일)
    PKief.material-icon-theme    # 아이콘
    usernamehw.errorlens        # 에러 실시간 표시
)

for ext in "${EXTENSIONS[@]}"; do
    code --install-extension "$ext" --force
done
fi
