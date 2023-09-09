ln -svf ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -svf ~/.dotfiles/.zshrc ~/.zshrc
mkdir ~/.config
rm -rf ~/.config/nvim
ln -svf ~/.dotfiles/.config/nvim ~/.config
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
