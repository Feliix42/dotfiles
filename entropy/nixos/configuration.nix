# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  # use unstable nixpkgs for some specific packages that are still in-dev: 
  # sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
  # sudo nix-channel --update
  unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
in
{
  imports =
    [ <nixos-hardware/lenovo/thinkpad/t14>
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Hardware support for Moonlander & U2F
      ./modules/hardware.nix

      # Network & VPN configuration
      ./modules/networking.nix

      ./modules/audio.nix
      ./modules/video.nix
      #./modules/v4l2loopback.nix
      ./modules/virtualisation.nix

      # Desktop configuration
      ./modules/sway.nix
      ./modules/kde.nix
      # old i3 compositor
      # ./modules/i3.nix

      ./modules/printing.nix
      ./modules/backup.nix

      # include and configure R
      ./modules/r.nix
      # python with modules
      ./modules/python.nix
    ];


  # set up LUKS discovery
  boot.initrd.luks.devices.cryptlvm.device = "/dev/disk/by-uuid/f382cd01-9048-4b1b-8a73-48e1f61e6c08";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ------------ kernel -------------------------------------------------------
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_19;

  # ------------ time, location & input ---------------------------------------
  # Set your time zone.
  time.timeZone = "Europe/Berlin";
  # geoclue2 does not yield a location at home, so I'll make the manual configuration the default
  # location.provider = "geoclue2";
  location.provider = "manual";
  # using the location of the cafe ascii should be good enough
  location.latitude = 51.0250869;
  location.longitude = 13.7210005;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    #font = "Lat2-Terminus16";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    keyMap = pkgs.lib.mkForce "uk";
  };
  # use the xkb-config from the X server
  console.useXkbConfig = true;

  # Configure keymap in X11
  services.xserver.layout = "gb";
  services.xserver.xkbOptions = "eurosign:e,ctrl:nocaps,compose:ralt";
  # enable touchpad support
  services.xserver.libinput.enable = true;


  # ------------ security -----------------------------------------------------
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.felix = {
    createHome = true;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "dialout" ]; # wheel: Enable ‘sudo’ for the user.
    group = "users";
    home = "/home/felix";
    shell = pkgs.fish;
  };

  # allow user felix to run openconnect without password
  security.sudo.extraRules = [
    {
      users = [ "felix" ];
      commands = [
        { command = "${pkgs.openconnect}/bin/openconnect"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  security.pam.u2f = {
    enable = true;
    cue = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "curses";
  };

  # ------------ programs -----------------------------------------------------
  programs.fish.enable = true;
  programs.vim.defaultEditor = true;

  services.emacs = {
    install = true;
    enable = false;
  };

  # List of packages installed in system profile.
  environment.systemPackages = with pkgs; [
    ## basic command line tooling
    wget
    w3m
    htop
    bat
    lsd
    ripgrep
    sshfs
    ncdu
    tldr
    unzip
    bind
    inetutils
    usbutils
    moreutils
    file
    mosh
    tmux
    libqalculate
    ## password management
    pass
    pinentry-curses
    ## admin foo
    ansible
    ## mail
    isync
    msmtp
    neomutt urlview
    notmuch
    ## Rust
    rustup
    cargo-flamegraph
    cargo-watch

    unstable.rust-analyzer
    unstable.helix
 
    ## other programming languages and compilers
    stack
    unstable.haskell-language-server
    gcc
    binutils-unwrapped
    gnumake
    cmake
    gdb
    ccls
    valgrind
    heaptrack
    #lingua-franca-ide 
    ## I heard you like man pages?
    man-pages
    ## git and friends
    #git
    #git-doc
    gitAndTools.gitFull
    gitAndTools.delta
    gitAndTools.gitui
    ## terminal, browsers, text editing, note taking
    alacritty
    vscodium
    neovim
    firefox-wayland
    # temporary
    brave
    unstable.obsidian
    ## time tracking
    watson
    hledger hledger-ui hledger-web
    ## file managers
    ranger
    xfce.thunar
    ## file sharing
    nextcloud-client
    ## document viewers
    pdfpc
    zathura
    ## image manipulation
    gimp
    inkscape
    libheif
    ## LaTeX
    texlive.combined.scheme-full
    ## Citation management
    zotero
    ## the eternal pain continues
    libreoffice-fresh
    ## video and media applications
    unstable.zoom-us
    teams
    youtube-dl
    mpv
    streamlink
    ffmpeg-full
    musikcube
    ## messenger
    slack
    tdesktop
    signal-desktop
    weechat
    ## networking
    openconnect
  ];

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
    wlr = {
      enable = true;
      settings = {
        screencast = {
          output_name = "eDP-1";
          max_fps = 30;
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
    };
  };

  # install fonts
  fonts.fonts = with pkgs; [
    font-awesome
    fira
    fira-code
    fira-code-symbols
    iosevka
    roboto
    roboto-mono
    roboto-slab
    open-sans
    overpass
    (nerdfonts.override {
      fonts = [ "FiraCode" "DroidSansMono" "Hack" "SourceCodePro" "RobotoMono" "Ubuntu" "UbuntuMono" ];
    })
  ];

  # periodic automated mail fetching
  systemd.user.services.mailfetch = {
    enable = true;
    description = "Automatically fetches new mails.";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Restart = "always";
      RestartSec = "60";
    };
    path = with pkgs; [ bash notmuch isync ];
    script = ''
      mbsync -a && /home/felix/.config/neomutt/notmuch-hook.sh
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

