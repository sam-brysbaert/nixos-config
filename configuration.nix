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
    sxhkd
    bspwm
  ];

  # fonts have to be listed separately
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    dejavu_fonts
    roboto-mono
    font-awesome
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

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
      
    displayManager.startx.enable = true;

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

  # set vim as default editor
  environment.variables = { EDITOR = "vim"; VISUAL = "vim"; };

  # enable trim to aid SSD performance;
  services.fstrim.enable = true;

  # enable ssh
  services.sshd.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

