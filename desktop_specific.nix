{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    steam
  ];

  networking = {
    hostName = "sam-nixos-desktop";
    
    # configuration for static ip
    interfaces.enp5s0.ipv4.addresses = [ { address = "192.168.0.15"; prefixLength = 24; }  ];
    defaultGateway = "192.168.0.1";
    nameservers = [ "1.1.1.1" ];

    # block certain websites
    extraHosts =
      ''
        127.0.0.1 www.reddit.com
        127.0.0.1 www.youtube.com

      '';
  };

  services.xserver = {
    
    # enable nvidia drivers
    videoDrivers = ["nvidia"];

    # fix for screen tearing on nvidia gpu
    screenSection = ''
      Option "metamodes" "nvidia-auto-select +0+0 { ForceCompositionPipeline = On }"
    '';

    # enable auto log-in
    displayManager.sddm.autoLogin.enable = true;

  };

  # enable wake-on-lan
  services.wakeonlan.interfaces = [{ interface = "enp5s0"; method = "magicpacket"; } ];

  # ssh 
  services.sshd.enable = true;
  services.openssh.forwardX11 = true;

  # activate plex
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  # for 32-bit games on steam
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

}
