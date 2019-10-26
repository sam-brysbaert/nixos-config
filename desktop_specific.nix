{ config, pkgs, ... }:

{
  networking.hostName = "sam-nixos-desktop"; # Define your hostname.

  services.xserver = {
    
    # enable nvidia drivers
    videoDrivers = ["nvidia"];

    # fix for screen tearing on nvidia gpu
    screenSection = ''
      Option "metamodes" "nvidia-auto-select +0+0 { ForceCompositionPipeline = On }"
    '';

    # enable auto log-in
    displayManager.sddm.autologin.enable = true;

  };

  # enable wake-on-lan
  services.wakeonlan.interfaces = [{ interface = "enp5s0"; method = "magicpacket"; } ];

  # activate plex
  services.plex = {
    enable = true;
    openFirewall = true;
  };

}
