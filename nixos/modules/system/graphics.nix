{config, ...}: {
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  # services.xserver.videoDrivers = ["noveau"];

  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;

  #   open = false;
  #   prime = {
  #     sync.enable = true;

  #     # offload = {
  #     #   enable = true;
  #     #   enableOffloadCmd = true;
  #     # };

  #     intelBusId = "PCI:0:2:0";
  #     nvidiaBusId = "PCI:1:0:0";
  #   };
  # };
}
