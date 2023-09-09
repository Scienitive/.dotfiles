ln -svf ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -svf ~/.dotfiles/.zshrc ~/.zshrc
mkdir ~/.config
rm -rf ~/.config/nvim
ln -svf ~/.dotfiles/.config/nvim ~/.config
rm -rf ~/.oh-my-zsh
ln -svf ~/.dotfiles/.oh-my-zsh ~/.
rm -rf ~/.tmux
ln -svf ~/.dotfiles/.tmux ~/.
