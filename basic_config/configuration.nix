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
    ];

  # allow non-free packages
  nixpkgs.config.allowUnfree = true;

  # packages to install
  environment.systemPackages = with pkgs; [
    stow
    gnupg
    git
    vim
    firefox
    
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
  
    # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

