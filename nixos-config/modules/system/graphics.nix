{...}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # services.xserver.videoDrivers = ["nvidia"];

  # hardware.nvidia.prime = {
  #   offload = {
  #     enable = true;
  #     enableOffloadCmd = true;
  #   };

  #   intelBusId = "PCI:0:2:0";
  #   nvidiaBusId = "PCI:1:0:0";
  # };
}
