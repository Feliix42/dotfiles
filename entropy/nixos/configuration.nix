# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, unstable, lib, ... }:

#let
  # use unstable nixpkgs for some specific packages that are still in-dev:
  # sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
  # sudo nix-channel --update
  #unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
#in
{
  imports =
    [
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

  # OVERRIDES ##########################################################
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
    "freeimage-unstable-2021-11-01"
  ];


  # set up LUKS discovery
  boot.initrd.luks.devices.cryptlvm.device = "/dev/disk/by-uuid/f382cd01-9048-4b1b-8a73-48e1f61e6c08";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };

  # ------------ kernel -------------------------------------------------------
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_7;

  services.fwupd.enable = true;

  # ------------ time, location & input ---------------------------------------
  # Set your time zone.
  time.timeZone = "Europe/Berlin"; # "US/Pacific"; 
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
  services.xserver.xkb.layout = "gb";
  services.xserver.xkb.options = "eurosign:e,ctrl:nocaps,compose:ralt";
  # enable touchpad support
  services.xserver.libinput.enable = true;

  # ------------ Nix Config ---------------------------------------------------
  nix =  {
    package = pkgs.nixFlakes;
    # the builders-use-substitutes is optional; useful when the builder has a faster internet connection than yours
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';
    buildMachines = [{
      # hostName = "ada";
      hostName = "141.30.52.34";
      sshUser = "builder";
      system = "x86_64-linux";
      # if the builder supports building for multiple architectures,
      # replace the previous line by, e.g.,
      # systems = ["x86_64-linux" "aarch64-linux"];
      maxJobs = 2;
      speedFactor = 2;
      supportedFeatures = [ "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
      # base64 -w0 /etc/ssh/ssh_host_ed25519_key.pub
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUlTcFY3cVJUZEdXVlpYNFlITnFYZXBYNjZUK0U1dGdCbnAwTlJOTmtKbzcgcm9vdEBhZGEK";
      sshKey = "/home/felix/.ssh/id_ed25519";
    # }
    # {
    #   hostName = "elm";
    #   sshUser = "builder";
    #   system = "x86_64-linux";
    #   # if the builder supports building for multiple architectures,
    #   # replace the previous line by, e.g.,
    #   # systems = ["x86_64-linux" "aarch64-linux"];
    #   maxJobs = 1;
    #   speedFactor = 1;
    #   supportedFeatures = [ "big-parallel" "kvm" ];
    #   mandatoryFeatures = [ ];
    #   publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUNXTk9oL3ozQjZmSXRGd2lTenlqeDBUTnIveUl6bHNsazdEeEtNcE5sdmwgcm9vdEBlbG0K";
    #   sshKey = "/home/felix/.ssh/id_ed25519";
    }] ;

    distributedBuilds = true;
    settings.trusted-users = [
      "root"
      "@wheel"
    ];
  };

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
    pinentryPackage = lib.mkForce pkgs.pinentry-curses;
  };

  # ------------ programs -----------------------------------------------------
  programs.fish.enable = true;

  # programs.vim.defaultEditor = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.ssh.setXAuthLocation = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
  };

  programs.mosh.enable = true;

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
  programs.command-not-found.enable = false;

  # List of packages installed in system profile.
  environment.systemPackages = with pkgs; [
    ## basic command line tooling
    wget
    w3m
    htop
    btop
    bat
    lsd
    unstable.eza
    ripgrep
    fzf
    tokei
    vim
    #sshfs
    ncdu
    tldr
    unzip
    bind
    inetutils
    usbutils
    moreutils
    file
    #tmux
    zellij
    libqalculate
    ## xdg-open
    xdg-utils
    ## shell extras
    nushell
    ## password management
    pass
    ## admin foo
    ansible
    ## mail
    isync
    msmtp
    neomutt urlscan
    notmuch
    aspell # spell checking in mail
    ## Rust
    rustup
    cargo-flamegraph
    cargo-watch

    unstable.rust-analyzer
    #unstable.helix

    ## other programming languages and compilers
    stack
    unstable.haskell-language-server
    gcc
    binutils-unwrapped
    gnumake
    cmake
    ninja
    gdb
    ccls
    # valgrind
    # heaptrack

    ## nix-community/comma
    comma
    nix-output-monitor
    nil

    # provided by my own overlay
    mlir
    circt
    llvmPackages_17.clang
    llvmPackages_17.lldb
    llvmPackages_17.libcxx
    llvmPackages_17.libcxxabi
    llvmPackages_17.libllvm
    llvmPackages_17.llvm-manpages
    llvmPackages_17.openmp
    llvmPackages_17.bintools
    clang-tools_17
    lit

    ## I heard you like man pages?
    man-pages
    ## git and friends
    gitAndTools.delta
    gitAndTools.gitui
    ## terminal, browsers, text editing, note taking
    alacritty
    # TODO(feliix42): Fix at some point!
    unstable.vscode.fhs
    tree-sitter # for NVIM completions
    ghostwriter
    unstable.obsidian
    ## file managers
    ranger
    ## file sharing
    nextcloud-client
    ## document viewers
    pdfpc
    zathura
    ## image manipulation
    # gimp
    inkscape
    libheif
    imagemagick
    ## LaTeX
    texlive.combined.scheme-full
    ## Citation management
    # TODO: Enable again when CVE is fixed
    #zotero
    ## the eternal pain continues
    libreoffice-fresh
    ## video and media applications
    zoom-us
    #unstable.teams
    spotify
    mpv
    ffmpeg-full
    musikcube
    ## messenger
    slack
    tdesktop
    signal-desktop
    ## networking
    openconnect
  ];

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
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
  fonts.packages = with pkgs; [
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
      fonts = [ "FiraCode" "DroidSansMono" "Hack" "SourceCodePro" "RobotoMono" "Ubuntu" "UbuntuMono" "Iosevka" "IosevkaTerm"];
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

