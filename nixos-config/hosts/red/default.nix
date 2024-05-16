{
  pkgs,
  config,
  inputs,
  system,
  ...
}: {
  imports = [./hardware.nix];

  # Programs
  programs.command-not-found.enable = true;

  programs.steam = {
    enable = false;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Packages
  environment.systemPackages = with pkgs; [
    bind
    bintools
    cifs-utils
    coreutils
    curl
    file
    git
    git-crypt
    killall
    parted
    gparted
    playerctl
    ripgrep
    wget
    bat
    bottom
    btop
    eza
    fzf
    mpv
    nano
    nmap
    nomacs
    nitch
    tldr
    p7zip
    pavucontrol
    pv
    unrar
    unzip
    zip
    libnotify
    glib
    shfmt
    wine
    zx
  ];

  # Services
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  services.printing = {
    enable = true;
    drivers = [pkgs.epson_201207w];
    browsing = true;
    defaultShared = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish.enable = true;
    publish.addresses = true;
    publish.userServices = true;
  };

  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.epson_201207w];
  };

  services.redis.servers = {
    "redis" = {
      enable = true;
      port = 6379;
    };
  };

  services.mysql = {
    enable = false;
    package = pkgs.mariadb;
  };

  services.gnome.gnome-keyring.enable = true;

  programs.adb.enable = true;

  modules.programs = {
    zsh.enable = true;
    kitty.enable = true;
    # fish.enable = true;
    # starship.enable = true;

    git.enable = true;
  };

  modules.services = {
    docker.enable = true;
  };

  # slow down rebuild
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.guest.enable = true;

  # User Account
  user = {
    name = "levi";
    description = "Levi Manoel";

    groups = ["adbusers" "docker" "plugdev" "networking" "vboxusers" "video" "wheel"];

    shellAliases = {
      ls = "exa";
      cat = "bat";

      gst = "git status";
      ga = "git add";
      gcmsg = "git commit -m";
      gp = "git push";
      gl = "git pull";
      gunst = "git restore --staged";
      gcp = "git cherry-pick";
      gd = "git diff";
      gds = "git diff --staged";
      gsw = "git switch";
    };

    packages = with pkgs; [
      alejandra
      beekeeper-studio
      d2
      dbeaver
      discord
      gimp
      google-chrome
      gh
      gtk-engine-murrine
      nil
      obsidian
      qbittorrent
      spotify
      stremio
      terraform
      ventoy-full
      vesktop
      vscode
      wpsoffice
      zed-editor
    ];

    home = {
      programs = {
        vscode.enable = true;
      };

      services = {
        flameshot.enable = true;
      };
    };

    sessionVariables = {
      GTK_THEME = "Gruvbox-Dark-B";
    };

    home.extraConfig = {
      home = {
        pointerCursor = {
          name = "phinger-cursors-dark";
          package = pkgs.phinger-cursors;
          size = 24;
          pointerCursor.gtk.enable = true;
          pointerCursor.x11.enable = true;
        };
      };

      gtk = {
        enable = true;

        font = {
          name = "Iosevka Comfy Motion";
          size = 10;
        };

        theme = {
          name = "Gruvbox-Dark-B";
          package = pkgs.gruvbox-gtk-theme;
        };

        iconTheme = {
          name = "Mint-Y-Sand";
          package = pkgs.cinnamon.mint-y-icons;
        };

        cursorTheme = {
          name = "phinger-cursors-dark";
          package = pkgs.phinger-cursors;
          size = 24;
        };

        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };

        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };
    };
  };

  # NVIDIA
  #  hardware.opengl = {
  #    enable = true;
  #    driSupport = true;
  #    driSupport32Bit = true;
  #  };

  #  services.xserver.videoDrivers = ["nvidia"];

  # hardware.nvidia = {
  # modesetting.enable = true;

  #  powerManagement.enable = false;
  #  powerManagement.finegrained = false;
  #  open = false;
  #  nvidiaSettings = true;
  #  package = config.boot.kernelPackages.nvidiaPackages.stable;

  #  prime = {
  #    offload = {
  #      enable = true;
  #      enableOffloadCmd = true;
  #    };
  #    intelBusId = "PCI:0:2:0";
  #    nvidiaBusId = "PCI:1:0:0";
  #  };
  #};
}
