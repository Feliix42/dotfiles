# manual locale override

export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="de_DE.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="de_DE.UTF-8"
export LC_NUMERIC="de_DE.UTF-8"
export LC_TIME="de_DE.UTF-8"
export LC_ALL="en_GB.UTF-8"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/Library/TeX/texbin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/Library/Python/3.8/bin"

export GOPATH="/Users/felix/.gostuff"

# FUCK configuration
thefuck --alias | source

# kitty terminal emulator auto completion
kitty + complete setup fish | source

# fancier ls
alias ls="lsd"

# better vscode
alias code="codium"

# fsr password store
alias fsrpass="env PASSWORD_STORE_DIR=/Users/felix/fsr/passwords pass"

## some aliases taken from old zshrc
alias full-update="brew update; brew upgrade; brew cask upgrade; brew cleanup; apm update --confirm false; rustup self update; rustup update"
alias l="lsd -la"
alias calculator="python3 -i -c 'from math import *'"
alias music="screen -dR music cmus"
alias pennmush="telnet mush.pennmush.org 4201"

## fluff
alias fucking="sudo"

# mache dinge
alias mache="make"
alias alles="all"
alias sauber="clean"
alias renne="run"

# custom temporary aliases
alias underrail="wine start 'C:\Program Files\Steam\steamapps\common\Underrail\underrail.exe'"
alias underrail-steam="wine start 'C:\Program Files\Steam\steam.exe' steam://run/250520 -no-cef-sandbox"


# initialize starship
eval (starship init fish)

## easily share small files via my uberspace
function share
    scp -q $argv gibbs:~/html/share/
    echo "https://share.felixwittwer.de/"$argv
    echo "https://share.felixwittwer.de/"$argv | pbcopy
end

###### Nix Setup ######
# include this plugin so nix will work
# https://github.com/NixOS/nix/issues/1512
# https://github.com/oh-my-fish/plugin-foreign-env
set fish_function_path $fish_function_path $HOME/.config/fish/plugin-foreign-env/functions

# initialize nix
fenv source '$HOME/.nix-profile/etc/profile.d/nix.sh' 
