#!/usr/bin/env bash

set -euo pipefail

printf '\033[33m


                       /$$                                            
                      | $$                                            
  /$$$$$$  /$$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$   /$$$$$$  /$$   /$$
 /$$__  $$| $$__  $$|_  $$_/   /$$__  $$ /$$__  $$ /$$__  $$| $$  | $$
| $$$$$$$$| $$  \ $$  | $$    | $$  \__/| $$  \ $$| $$  \ $$| $$  | $$
| $$_____/| $$  | $$  | $$ /$$| $$      | $$  | $$| $$  | $$| $$  | $$
|  $$$$$$$| $$  | $$  |  $$$$/| $$      |  $$$$$$/| $$$$$$$/|  $$$$$$$
 \_______/|__/  |__/   \___/  |__/       \______/ | $$____/  \____  $$
                                                  | $$       /$$  | $$
                                                  | $$      |  $$$$$$/
                                                  |__/       \______/ 




This script will now install the dotfiles and configurations for `entropy`.

\033[39m'

printf '\033[31m[note] Note that you have to manually link the nixos configuration and rebuild the system before running this script.
\033[39m'
echo "[note] Please make sure a GPG private key is installed."
echo "[note] Finally, you should have a working ssh key in place to interact with github and other servers. Note that the existing SSH config will be overwritten."
read -p "Are you ready to go? [y/n] " ready
if [ $ready != "y" ]; then
    exit
fi

# sudo -v

# general preparations
mkdir -p ~/.config

# set up pass
printf "\033[33m[info] Linking config files\033[39m"
# this must be run in the home network
git clone felix@decima:~/pass-backup ~/.password-store

# set up vim
printf "\033[33m[info] Setting up vim\033[39m"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -s $PWD/.vimrc ~/.vimrc
vim -c "PlugInstall"

# set up emacs
printf "\033[33m[info] Setting up emacs\033[39m"
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

# set up mail
printf "\033[33m[info] Configuring Neomutt - your GPG password may be required.\033[39m"
cd mail
# generate mbsyncrc
sed -e "s/{{PASSWORD}}/$(pass mail/tud | head -1)/" -e "s/{{USER}}/$(pass mail/tud-user)/" template.mbsyncrc > .mbsyncrc
sed -e "s/{{USER}}/$(pass mail/tud-user)/" template.msmtprc > .msmtprc
# link files
cd ..
ln -s $PWD/mail/neomutt/ ~/.config/neomutt
ln -s $PWD/mail/.mailcap ~/.mailcap
ln -s $PWD/mail/.mbsyncrc ~/.mbsyncrc
ln -s $PWD/mail/.msmtprc ~/.msmtprc
ln -s $PWD/mail/.notmuch-config ~/.notmuch-config
mkdir -p ~/.mail/tu-dresden
notmuch new

# set up openvpn connection
printf "\033[33m[info] Configuring OpenVPN\033[39m"
cd vpn
pass mail/tud-user | head -1 >> credentials.txt
pass mail/tud | head -1 >> credentials.txt
cd ..
ln -s $PWD/vpn ~/.config/vpn

# link other dotfiles
printf "\033[33m[info] Linking config files\033[39m"
ln -s $PWD/kitty/ ~/.config/kitty
ln -s $PWD/alacritty ~/.config/alacritty
ln -s $PWD/nyxt/ ~/.config/next
ln -s $PWD/mako/ ~/.config/mako
ln -s $PWD/.urlview ~/.urlview
ln -s $PWD/.gitconfig ~/.gitconfig
ln -s $PWD/git-commit-template.txt ~/.gitcommit_template
mkdir -p ~/.config/fish/
ln -s $PWD/config.fish ~/.config/fish/config.fish
## i3 things
ln -s $PWD/i3 ~/.config/i3
ln -s $PWD/i3status-rust ~/.config/i3status-rust
ln -s $PWD/dunst ~/.config/dunst
## sway things
ln -s $PWD/sway ~/.config/sway
ln -s $PWD/kanshi ~/.config/kanshi

ln -s $PWD/mpv ~/.config/mpv
ln -s $PWD/waybar ~/.config/waybar



# set default browser, enable redshift etc
printf "\033[33m[info] Setting up some defaults\033[39m"
xdg-settings set default-web-browser firefox.desktop

mkdir -p ~/.config/systemd/user/default.target.wants
touch ~/.config/systemd/user/default.target.wants/redshift.service
