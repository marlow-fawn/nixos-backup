{ config, lib, pkgs, ... }:


{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # GPU
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "intel" ];
  

  # Networking
  networking.hostName = "marlow-nixos"; 
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  
  # Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";
  
  # Env vars
  environment.variables = {
    EDITOR = "vim";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
    XDG_PORTAL_FORCE = "1";
  };
  
  # Users
  users.users.marlow = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
  };

  ### Packages

  # Packages
  environment.systemPackages = with pkgs; [
    git
    wget
    google-chrome
    discord-ptb
    tree
    brightnessctl
    xdg-desktop-portal xdg-desktop-portal-wlr
  ];
  nixpkgs.config.allowUnfree = true; 
  
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

  system.stateVersion = "24.11";
}

