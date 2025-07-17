{ config, lib, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
    ];

  # Nix settings
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  nix.settings.auto-optimise-store = true;
  boot.loader.systemd-boot.configurationLimit = 5; 

  time.timeZone = "America/New_York";
  system.stateVersion = "24.11";

  # Env vars
  environment.variables = {
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
    XDG_DESKTOP_PORTAL = "xdg-desktop-portal-wlr";
    GTK_USE_PORTAL = 1;
    GTK_THEME = "Adwaita:dark";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot = {
    consoleLogLevel = 1;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
    ];
  };

  # GPU
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "modesetting" ];

  # Networking
  networking = {
    hostName = "marlow-nixos"; 
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.powersave = false;
    };
  };

  # SSH
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      UseDns = true;
      X11Forwarding = true;
    };
  };

  # Network security
  services.fail2ban.enable = true;
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 5353 ];           # 5353 = mDNS (used by Avahi)
    allowedTCPPorts = [ 22 631 ];
  };

  # JP Input
  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = [
    pkgs.fcitx5-mozc
    pkgs.fcitx5-gtk
    pkgs.fcitx5-configtool
  ];

  services.resolved = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # Adds GTK support
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.tailscale = {
    enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  services.blueman.enable = true;
  
  # Users
  users.users.marlow = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "adbusers" "kvm"]; # Enable ‘sudo’ for the user.
  };

  ### Packages

  # Packages
  nixpkgs.config.allowUnfree = true; 
  programs.adb.enable = true;
  environment.systemPackages = with pkgs; [
    # Work 
    sshfs jdk17 zip unzip
    zoom-us slack texliveSmall
    #python3 gcc libgcc cmake 

    # Dev
    git wget clang 
    jetbrains.pycharm-community
    jetbrains.idea-community
    
    # Desktop
    google-chrome discord-ptb obsidian brave
    
    # Hobbies
    zrythm spotifywm gimp
    
    # Util
    tree brightnessctl gammastep libnotify
    grim slurp swappy vlc

  ];
 
  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # Font Packages
  #fonts.packages = with pkgs; [
  #  nerdfonts
  #];
  
  ### Programs
#  programs.obs-studio = {
#    enable = true;
#    plugins = with pkgs.obs-studio-plugins; [
#      wlrobs
#      obs-backgroundremoval
#      obs-pipewire-audio-capture
#    ];
#  };

  # Sway
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      wl-clipboard
      foot
      mako
      yambar
      fuzzel
    ]; 
  };

  programs.xwayland.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true; # Optional for minimal setups
  
  # Vim
  programs.neovim = {
    enable = true; 
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
  };
  
  # Set vim as default sudo editor
  security.sudo.extraConfig = ''
    Defaults editor=/run/current-system/sw/bin/vim
  '';
  
  ### Services
  
  # Display manager, login screen
  services.displayManager = {
    ly.enable = true;
    defaultSession = "sway";
  };

  # Power settings
  services.tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        };
  };

  # Printing
  services.printing.enable = true;
  
  #Audio
  services.pipewire.enable = true;
  
}

