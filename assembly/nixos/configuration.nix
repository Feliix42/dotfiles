# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Hardware support for Voyager & U2F
      ./modules/hardware.nix

      # TUD inventory
      ./modules/glpi.nix

      # Network & VPN configuration
      ./modules/networking.nix

      ./modules/audio.nix
      ./modules/video.nix
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


  # TODO:
  # - nix builders
  # - graphics settings
  # - fingerprint?
  # - notmuch/neomutt setup

  # set up LUKS discovery
  boot.initrd.luks.devices.cryptlvm.device = "/dev/disk/by-uuid/485e7755-e77d-4314-abe1-a30c0869a3d5";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "assembly";

  # ------------ kernel -------------------------------------------------------
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.fwupd.enable = true;

  # ------------ time, location & input ---------------------------------------
  # Set your time zone.
  time.timeZone = "Europe/Berlin"; # "US/Pacific"; 
  #time.timeZone = "America/New_York";
  # geoclue2 does not yield a location at home, so I'll make the manual configuration the default
  location.provider = "manual";
  # using the location of the cafe ascii should be good enough
  location.latitude = 51.0250869;
  location.longitude = 13.7210005;
  # NY State
  #location.latitude = 43.084902;
  #location.longitude = -77.678352;

  services.chrony.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    #font = "Lat2-Terminus16";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    keyMap = pkgs.lib.mkForce "us";
  };
  # use the xkb-config from the X server
  console.useXkbConfig = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,ctrl:nocaps,compose:ralt";
  # enable touchpad support
  services.libinput.enable = true;

  # ------------ Nix Config ---------------------------------------------------
  nixpkgs.config.allowUnfree = true;

  nix =  {
    package = pkgs.nixVersions.stable;
    # the builders-use-substitutes is optional; useful when the builder has a faster internet connection than yours
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';

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

  security.pam.u2f = {
    enable = true;
    settings.cue = true;
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
    plugins = with pkgs; [ thunar-archive-plugin thunar-volman ];
  };

  programs.firefox = {
    enable = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
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
    eza
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
    tmux
    libqalculate
    ## xdg-open
    xdg-utils
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
    thunderbird
    kdePackages.filelight
    ## Rust
    rustup
    cargo-flamegraph
    cargo-watch

    rust-analyzer
    helix

    ## other programming languages and compilers
    # stack
    # haskell-language-server
    gcc
    binutils-unwrapped
    gnumake
    cmake
    ninja
    gdb
    ccls

    ## nix-community/comma
    comma
    nix-output-monitor
    nil

    # provided by my own overlay
    # mlir
    #circt
    llvmPackages_22.clang
    llvmPackages_22.lldb
    llvmPackages_22.libcxx
    #llvmPackages_20.libcxxabi
    llvmPackages_22.libllvm
    llvmPackages_22.llvm-manpages
    llvmPackages_22.openmp
    llvmPackages_22.bintools
    llvmPackages_22.clang-tools
    llvmPackages_22.mlir
    lit

    # Let's give radicle a shot
    radicle-node
    radicle-tui
    radicle-desktop

    ## I heard you like man pages?
    man-pages
    ## git and friends
    delta
    gitui
    difftastic
    ## terminal, browsers, text editing, note taking
    ghostty
    nautilus
    tree-sitter # for NVIM completions
    obsidian
    zed-editor
    ## file managers
    ## file sharing
    #nextcloud-client
    ## document viewers
    pdfpc
    zathura
    ## image manipulation
    inkscape
    libheif
    imagemagick
    ## LaTeX
    texliveFull
    ## Citation management
    zotero
    ## the eternal pain continues
    libreoffice-fresh
    ## video and media applications
    zoom-us
    spotify
    mpv
    ffmpeg-full
    musikcube
    playerctl
    ## messenger
    signal-desktop
  ];

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      kdePackages.xdg-desktop-portal-kde
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
    source-sans
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.hack
    nerd-fonts.sauce-code-pro
    nerd-fonts.roboto-mono
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
  ];


  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

