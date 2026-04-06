if ($IsWindows) {
    Write-Host "==> Installing core tools for Windows..."
    choco install starship zoxide fzf ripgrep bat eza fd neovim lazygit tmux -y
}
