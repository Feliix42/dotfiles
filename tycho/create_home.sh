#!/usr/bin/env bash

printf '\033[33m


   /$$                         /$$
  | $$                        | $$
 /$$$$$$   /$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$ 
|_  $$_/  | $$  | $$ /$$_____/| $$__  $$ /$$__  $$
  | $$    | $$  | $$| $$      | $$  \ $$| $$  \ $$
  | $$ /$$| $$  | $$| $$      | $$  | $$| $$  | $$
  |  $$$$/|  $$$$$$$|  $$$$$$$| $$  | $$|  $$$$$$/
   \___/   \____  $$ \_______/|__/  |__/ \______/ 
           /$$  | $$
          |  $$$$$$/
           \______/
                                                                                                                


This script will now install the dotfiles and configurations for `tycho`.
\033[39m'

echo "[note] Please make sure you have a working version of gpg installed (e.g., GPGTools)."
echo "[note] Also, please make sure a private key is installed."
echo "[note] Finally, you should have a working ssh config in place to interact with github and other servers."
read -p "Are you ready to go? [y/n] " ready
if [ $ready != "y" ]; then
    exit
fi

# ~/.macos — https://mths.be/macos

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

printf "\033[33m[info] Setting Hostname\033[39m"
# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName "tycho"
sudo scutil --set HostName "tycho"
sudo scutil --set LocalHostName "tycho"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "tycho"


printf "\033[33m[info] Linking config files\033[39m"
ln -s $PWD/.gitconfig ~/.gitconfig
ln -s $PWD/.global_gitignore ~/.global_gitignore
ln -s $PWD/git-commit-template.txt ~/.gitcommit_template

mkdir -p ~/.config/alacritty
ln -s $PWD/terminal/alacritty.yml ~/.config/alacritty/alacritty.yml
# enable font smoothing in alacritty
defaults write -g AppleFontSmoothing -int 0

ln -s $PWD/kitty/ ~/.config/kitty

touch ~/.hushlogin
ln -s $PWD/.yabairc ~/.yabairc


printf "\033[33m[info] Installing Homebrew\033[39m"
# we need the xcode tools
xcode-select --install
if test ! $(which brew); then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

printf "\033[33m[info] Installing nix\033[39m"
if test ! $(which nix-env); then
    curl -L https://nixos.org/nix/install | sh
fi

# TODO: Need to source?
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --update

printf "\033[33m[info] Installing some basic binaries\033[39m"
brew install fish
sudo echo "/usr/local/bin/fish" >> /etc/shells
chsh -s /usr/local/bin/fish

binaries=(
    pass
    git
    keepingyouawake
    alacritty
    starship
    lsd
    bat
    homebrew/cask-fonts/font-hack-nerd-font
    homebrew/cask-versions/firefox-nightly
)

brew install ${binaries[@]}


printf "\033[33m[info] Cloning password store\033[39m"
git clone felix@decima:~/pass-backup ~/.password-store


printf "\033[33m[info] Setting up neomutt\033[39m"
# TODO:
# 1: Install necessary packages via brew/nix
# Mail
# 2: fetch the password store repo



printf "\033[33m[info] Setting up Fish Shell\033[39m"
mkdir -p ~/.config/fish/
ln -s $PWD/terminal/config.fish ~/.config/fish/config.fish
git clone git@github.com:oh-my-fish/plugin-foreign-env.git ~/.config/fish/plugin-foreign-env

printf "\033[33m[info] Setting up vim\033[39m"

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -s $PWD/.vimrc ~/.vimrc
vim -c "PlugInstall"


printf "\033[33m[info] Setting up vim\033[39m"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
ln -s $PWD/nvim ~/.config/nvim
nvim -c "PlugInstall"


