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
#    plymouth = {
#      enable = true;
#      theme = "rings";
#      themePackages = with pkgs; [
#        # By default we would install all themes
#        (adi1090x-plymouth-themes.override {
#          selected_themes = [ "rings" ];
#        })
#      ];
#    };

    # Enable "Silent boot"
    #consoleLogLevel = 3;
    #initrd.verbose = false;
    #kernelParams = [
    #  "quiet"
    #  "splash"
    #  "boot.shell_on_fail"
    #  "udev.log_priority=3"
    #  "rd.systemd.show_status=auto"
    # ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    #loader.timeout = 0;
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
    allowedTCPPorts = [ 22 ];
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
    # Work 
    jetbrains.idea-community sshfs jdk17
    zoom-us slack texliveSmall
    python3

    # Dev
    git wget clang 

    # Desktop
    google-chrome discord-ptb obsidian
    
    # Hobbies
    zrythm spotifywm
    
    # Util
    tree brightnessctl gammastep libnotify
    grim slurp swappy vlc

  ];
  
  # Font Packages
  fonts.packages = with pkgs; [
    nerdfonts
  ];
  
  ### Programs
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };
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

