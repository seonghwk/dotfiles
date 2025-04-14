# seonghwk-dotfiles

Reference : [Dotfiles: Best way to store in a bare git repository](https://www.atlassian.com/git/tutorials/dotfileshttps://www.atlassian.com/git/tutorials/dotfiles)

## Installing your dotfiles onto a new system (or migrate to this setup)

- Prior to the installation make sure you have committed the alias to your `.bashrc` or `.zsh`:
- And that your source repository ignores the folder where you'll clone it, so that you don't create weird recursion problems:
- Now clone your dotfiles into a bare repository in a "dot" folder of your $HOME:
- Set the flag `showUntrackedFiles` to `no` on this specific (local) repository:

```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo ".dotfilesdotfiles" >> .gitignore
git clone --bare https://github.com/seonghwk/dotfiles.git $HOME/.dotfiles
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
```
