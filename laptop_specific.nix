{ config, pkgs, ... }:

{

  networking = {
    hostName = "sam-nixos-laptop";
    networkmanager.enable = true;
    dhcpcd.enable = false;
  };

  # enable tlp to help save battery life
  services.tlp.enable = true;

  # touchpad
  services.xserver.libinput = {
    enable = true;
    naturalScrolling = true;
  };
  
}
