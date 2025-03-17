{ config, lib, pkgs, ... }:


{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Set vim as default sudo editor
  security.sudo.extraConfig = ''
    Defaults editor=/run/current-system/sw/bin/vim
  '';

  # Networking
  networking.hostName = "marlow-nixos"; 
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";
  
  # Env vars
  environment.variables = {
    GTK_THEME = "Adwaita:dark";
    EDITOR = "vim";
  };
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  users.users.marlow = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
  };

  # Packages
  nixpkgs.config.allowUnfree = true; 
  
  programs.light = {
    enable = true;
    brightnessKeys.enable = true;
  };
  
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      swayidle
      wl-clipboard
      foot
      wlr-randr
      mako
      swaylock
      waybar
    ]; 
  };


  programs.vim = {
    enable = true;  
  };
  
  services.displayManager = {
    ly.enable = true;
    #autoLogin.enable = true;
    #autoLogin.user = "marlow";
    defaultSession = "sway";
  };

  environment.systemPackages = with pkgs; [
    git
    wget
    google-chrome
    discord-ptb
    tree
    brightnessctl
    greetd.wlgreet
    greetd.gtkgreet
  ];

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
  ];
  
  # GPU Hardware
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "intel" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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
  system.stateVersion = "24.11"; # Did you read the comment?

}

