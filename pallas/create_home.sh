#!/usr/bin/env bash

printf '\033[33m

      ___           ___           ___       ___       ___           ___     
     /\  \         /\  \         /\__\     /\__\     /\  \         /\  \    
    /::\  \       /::\  \       /:/  /    /:/  /    /::\  \       /::\  \   
   /:/\:\  \     /:/\:\  \     /:/  /    /:/  /    /:/\:\  \     /:/\ \  \  
  /::\~\:\  \   /::\~\:\  \   /:/  /    /:/  /    /::\~\:\  \   _\:\~\ \  \ 
 /:/\:\ \:\__\ /:/\:\ \:\__\ /:/__/    /:/__/    /:/\:\ \:\__\ /\ \:\ \ \__\
 \/__\:\/:/  / \/__\:\/:/  / \:\  \    \:\  \    \/__\:\/:/  / \:\ \:\ \/__/
      \::/  /       \::/  /   \:\  \    \:\  \        \::/  /   \:\ \:\__\  
       \/__/        /:/  /     \:\  \    \:\  \       /:/  /     \:\/:/  /  
                   /:/  /       \:\__\    \:\__\     /:/  /       \::/  /   
                   \/__/         \/__/     \/__/     \/__/         \/__/    


This script will now install the dotfiles and configurations for `pallas`.
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
sudo scutil --set ComputerName "pallas"
sudo scutil --set HostName "pallas"
sudo scutil --set LocalHostName "pallas"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "pallas"


printf "\033[33m[info] Linking config files\033[39m"
ln -s $PWD/.gitconfig ~/.gitconfig
ln -s $PWD/.global_gitignore ~/.global_gitignore
ln -s $PWD/git-commit-template.txt ~/.gitcommit_template

mkdir -p ~/.config/alacritty
ln -s $PWD/terminal/alacritty.toml ~/.config/alacritty/alacritty.toml
# enable font smoothing in alacritty
defaults write -g AppleFontSmoothing -int 0

ln -s $PWD/terminal/wezterm/ ~/.config/wezterm

touch ~/.hushlogin
# ln -s $PWD/.yabairc ~/.yabairc


printf "\033[33m[info] Installing Homebrew\033[39m"
# we need the xcode tools
xcode-select --install
if test ! $(which brew); then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
echo >> /Users/felix/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/felix/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

printf "\033[33m[info] Installing some basic binaries\033[39m"
brew install fish
sudo echo "/opt/homebrew/bin/fish" >> /etc/shells
chsh -s /opt/homebrew/bin/fish

# required for Intel applications
softwareupdate --install-rosetta --agree-to-license

binaries=(
    pass
    git
    ncdu
    tldr
    gnu-tar
    gnu-sed
    neomutt
    msmtp
    isync
    notmuch
    borgbackup
    helix
    rust-analyzer
    git-delta
    btop
    cmake
    curl
    ffmpeg
    flex
    bison
    fzf
    gpgme
    hledger
    imagemagick
    jq
    librsvg
    llvm
    lua
    go
    mosh
    ninja
    pdfpc
    zola
    zellij
    yt-dlp
    xkcd
    wget
    unzip
    tree
    tree-sitter
    tmux
    ripgrep
    qrencode
    python
    pygments
    neovim
    bitwarden
    keepingyouawake
    alacritty
    wezterm
    starship
    lsd
    bat
    arduino
    adobe-acrobat-reader
    audacity
    calibre
    discord
    homebrew/cask/docker
    dropbox
    firefox@nightly
    font-hack-nerd-font
    font-iosevka
    font-iosevka-nerd-font
    font-iosevka-term-nerd-font
    gimp
    gitkraken
    gog-galaxy
    gstreamer-runtime
    imhex
    inkscape
    keepingyouawake
    libreoffice
    mactex
    magicavoxel
    mark-text
    homebrew/cask/neovide
    obsidian
    homebrew/cask/openttd
    signal
    spotify
    steam
    stolendata-mpv
    telegram
    temurin
    thunderbird
    tor-browser
    virtualbox
    vlc
    vscodium
    wezterm
    wine-stable
    zoom
    zotero
    zsa-wally
)

brew install ${binaries[@]}

brew install --HEAD tbvdm/tap/sigtop


printf "\033[33m[info] Cloning password store\033[39m"
git clone git@code.dummyco.de:feliix42/pass.git ~/.password-store


printf "\033[33m[info] Setting up neomutt\033[39m"
ln -s $PWD/mail/.mailcap ~/.mailcap
ln -s $PWD/mail/.mbsyncrc ~/.mbsyncrc
ln -s $PWD/mail/.msmtprc ~/.msmtprc
ln -s $PWD/mail/.notmuch-config ~/.notmuch-config
ln -s $PWD/mail/neomutt ~/.config/neomutt

# TODO:
# fetch?


printf "\033[33m[info] Setting up Fish Shell\033[39m"
mkdir -p ~/.config/fish/
ln -s $PWD/terminal/config.fish ~/.config/fish/config.fish

printf "\033[33m[info] Setting up vim\033[39m"

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -s $PWD/.vimrc ~/.vimrc
vim -c "PlugInstall"


printf "\033[33m[info] Setting up nvim\033[39m"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
ln -s $PWD/nvim ~/.config/nvim
nvim -c "PlugInstall"


