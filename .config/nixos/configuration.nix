{ config, lib, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./intranet.nix
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
    EDITOR = "vim";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
    XDG_DESKTOP_PORTAL = "xdg-desktop-portal-wlr";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # GPU
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "intel" ];

  # Networking
  networking = {
    hostName = "marlow-nixos"; 
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.powersave = false;
    };
  };

  services.resolved = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
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
    extraGroups = [ "wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
  };

  ### Packages

  # Packages
  nixpkgs.config.allowUnfree = true; 
  
  environment.systemPackages = with pkgs; [
    git wget
    google-chrome discord-ptb obsidian
    tree brightnessctl
    gammastep
    spotifywm
  ];
  
  # Font Packages
  fonts.packages = with pkgs; [
    fira-code fira-code-symbols
    font-awesome
    noto-fonts noto-fonts-cjk-sans noto-fonts-emoji
  ];
  
  ### Programs

  # Sway
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      swayidle
      wl-clipboard
      foot
      wlr-randr
      mako
      swaylock
      yambar
      fuzzel
    ]; 
  };
  
  # Vim
  programs.vim = {
    enable = true;  
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

          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

         #Optional helps save long term battery health
         START_CHARGE_THRESH_BAT0 = 50; 
         STOP_CHARGE_THRESH_BAT0 = 90;

        };
  };

  # Printing
  services.printing.enable = true;
  
  #Audio
  services.pipewire.enable = true;
  
}

