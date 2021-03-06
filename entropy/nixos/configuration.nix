# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # include and configure R
      ./modules/r.nix
      # python with modules
      ./modules/python.nix
      # Wayland
      ./modules/sway.nix
      # old i3 compositor
      # ./modules/i3.nix
    ];

  # set up LUKS discovery
  boot.initrd.luks.devices.cryptlvm.device = "/dev/disk/by-uuid/f382cd01-9048-4b1b-8a73-48e1f61e6c08";

  # make the screen usable
  #hardware.video.hidpi.enable = true;
  #services.xserver.dpi = 180;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # enable powertop for saving power
  #powerManagement.powertop.enable = true;

  networking.hostName = "entropy"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # geoclue2 does not yield a location at home, so I'll make the manual configuration the default
  # location.provider = "geoclue2";
  location.provider = "manual";
  # using the location of the cafe ascii should be good enough
  location.latitude = 51.0250869;
  location.longitude = 13.7210005;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  # USB-C dock
  networking.interfaces.enp0s20f0u2u1.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  nixpkgs.config = {
    # enable hardware-accelerated graphics
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      # add nixpkgs for unstable package sources
      #unstable = import <nixpkgs> {
        #config = config.nixpkgs.config;
      #};
    };
    # allow unfree licenced packges
    allowUnfree = true;
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

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
  services.xserver.xkbOptions = "eurosign:e,ctrl:nocaps,compose:prsc";
  # enable touchpad support
  services.xserver.libinput.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.epson-escpr
  ];

  # set up my printer at home
  hardware.printers.ensurePrinters = [
    {
      description = "My private printer";
      deviceUri = "https://192.168.178.30:631/ipp/print";
      location = "Home";
      model = "epson-inkjet-printer-escpr/Epson-XP-322_323_325_Series-epson-escpr-en.ppd";
      name = "Home";
    }
  ];

  # setup the printers at work
  #hardware.printers.ensurePrinters = [
    #{
      #description = "CC printer";
      #deviceUri = "";
      #location = "BAR/III51";
      #model = "Ricoh-MP_C307_PS.ppd";
      #name = "CC_small";
    #}
    #{
      #description = "PD printer (A3)";
      #deviceUri = "";
      #location = "BAR/III71B";
      #model = "Ricoh-MP_C3004_PS.ppd";
      #name = "PD_Chair";
    #}
  #];

  # Enable sound.
  sound.enable = true;
  # configure pulseaudio to work with bluetooth headsets using aptx
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    # the full package is necessary for BT support
    package = pkgs.pulseaudioFull;
    # switch to bluetooth automatically if they are connected
    extraConfig = "
      load-module module-switch-on-connect
      load-module module-bluetooth-policy auto_switch=2
    ";
  };
  nixpkgs.config.pulseaudio = true;

  # enable bluetooth in general and add a simple tool for connecting devices
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    # enable A2DP
    config = {
      General = {
        Enable = "Source,Sink,Media"; 
        Disable = "Socket";
      };
    };
  };
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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

  ## enable fingerprint reader
  #services.fprintd.enable = true;
  #security.pam.services.login.fprintAuth = true;
  ##security.pam.services.xscreensaver.fprintAuth = true;
  #security.pam.services.sudo.fprintAuth = true;

  # set up virtualization with virtualbox
  virtualisation.virtualbox.host.enable = true;
  # I'm gonna keep this disabled for the sake of my sanity
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "felix" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ## basic command line tooling
    wget
    vim
    w3m
    htop
    bat
    lsd
    ripgrep
    sshfs
    ncdu
    tldr
    unzip
    ncat
    bind
    inetutils
    usbutils
    screen
    moreutils
    file
    ## audio management
    pavucontrol
    ## password management
    pass
    pinentry-curses
    ## mail
    isync
    msmtp
    neomutt urlview
    notmuch
    ## programming languages and compilers
    rustup
    cargo-flamegraph
    cargo-watch
    # python3
    stack
    haskellPackages.haskell-language-server
    gcc
    binutils-unwrapped
    gnumake
    cmake
    gdb
    valgrind
    heaptrack
    ## I heard you like man pages?
    man-pages
    ## git and friends
    git
    gitAndTools.delta
    gitAndTools.gitui
    ## terminal, browsers, text editing
    kitty
    vscodium
    eclipses.eclipse-platform
    typora
    firefox-wayland
    torbrowser
    next
    rstudio
    ## time tracking
    watson
    ## file managers
    ranger
    xfce.thunar
    ## document viewers
    mupdf
    pdfpc
    zathura
    ## PDF manipulation
    podofo
    poppler_utils
    ## image manipulation
    gimp
    inkscape
    libheif
    ## LaTeX
    texlive.combined.scheme-full
    ## the eternal pain continues
    libreoffice-fresh
    ## video and media applications
    zoom-us
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
    (weechat.override {
      configure = { availablePlugins, ... }: {
        scripts = with pkgs.weechatScripts; [
          wee-slack
          # weechat-matrix
        ];
      };
      # extraBuildInputs = [ python38Packages.Logbook ];
    })
    ## networking
    openconnect
  ];

  # install fonts
  fonts.fonts = with pkgs; [
    font-awesome
    fira
    fira-code
    fira-code-symbols
    roboto
    roboto-mono
    roboto-slab
    open-sans
    overpass
    (nerdfonts.override {
      fonts = [ "FiraCode" "DroidSansMono" "Hack" "SourceCodePro" "RobotoMono" "Ubuntu" "UbuntuMono" ];
    })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.fish.enable = true;
  programs.vim.defaultEditor = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "curses";
  };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.udev.packages = [ pkgs.libu2f-host ];
  # for SAMBA file shares
  services.gvfs.enable = true;

  # allow brightness control
  services.illum.enable = true;

  # enable OpenVPN for connecting to the TUD network
  services.openvpn.servers.tud = {
    config = '' config /home/felix/.config/vpn/TUD.ovpn '';
    autoStart = false; #true;
    updateResolvConf = true;
  };

  # periodic automated mail fetching
  systemd.user.services.mailfetch = {
    enable = true;
    description = "Automatically fetches for new mail when the network is up";
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

