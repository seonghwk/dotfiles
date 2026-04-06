# Windows 전용 VS Code 설정 동기화 스크립트 (PowerShell)

$source = "$HOME\.local\share\chezmoi\common\vscode-settings.json"
$appdata = $env:APPDATA
$destDir = "$appdata\Code\User"
$destFile = "$destDir\settings.json"

# 1. 설정 폴더가 없으면 생성
if (-not (Test-Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir -Force
}

# 2. 파일 동기화 (Windows에서는 하드링크가 가장 안전하고 빠름)
# 하드링크를 걸면 원본 파일이 변할 때 VS Code 설정도 즉시 변합니다.
if (Test-Path $source) {
    Write-Host "==> Syncing VS Code settings on Windows..."
    # 기존 파일이 있다면 삭제 후 하드링크 생성
    if (Test-Path $destFile) {
        Remove-Item $destFile -Force
    }
    New-Item -ItemType HardLink -Path $destFile -Target $source -Force
    Write-Host "==> VS Code settings synced successfully!"
}
else {
    Write-Warning "Source settings file not found at $source"
}
