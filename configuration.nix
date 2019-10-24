# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  chosenUsername = "sam";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./desktop_specific.nix
      #./laptop_specific.nix
    ];

  # allow non-free packages
  nixpkgs.config.allowUnfree = true;

  # packages to install
  environment.systemPackages = with pkgs; [
    wget
    vimHugeX # this instead of vim to get X clipboard support (i.e. "+y)
    firefox
    nox
    stow
    polybar
    termite
    gotop
    google-chrome
    zip
    unzip
    dmenu
    feh
    pass
    rofi
    mpv
    scrot
    numlockx
    zathura
    playerctl
    redshift
    vscode
    gnupg
    git
    tree
    killall
  ];

  # fonts have to be listed separately
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    dejavu_fonts
    roboto-mono
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # enable networkmanager
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  # auto upgrade nixOS to the latest version
  system.autoUpgrade.enable = true;

  # activate plex
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # enable intel microcode updates
  hardware.cpu.intel.updateMicrocode = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver = {

    # Enable the X11 windowing system.
    enable = true;
      
    # set bspwm as window manager
    windowManager.bspwm.enable = true;
    windowManager.default = "bspwm";

    displayManager.sddm = {
      enable = true;
      autoLogin.enable = true;
      autoLogin.user = chosenUsername;
      autoNumlock = true;
    };

    # stop display manager from choosing xterm session automatically instead of my chosen window manager
    desktopManager.xterm.enable = false;
    desktopManager.default = "none";

  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${chosenUsername} = {
    isNormalUser = true;
    home = "/home/${chosenUsername}";
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  # stop the user from having to enter a password to use sudo
  security.sudo.wheelNeedsPassword = false;

  # set fish as default shell for user
  programs.fish.enable = true;
  users.extraUsers.${chosenUsername} = {
    shell = "/run/current-system/sw/bin/fish";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

