#!/bin/bash
# TPM이 없으면 클론
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
