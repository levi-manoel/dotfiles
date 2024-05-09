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
    playerctl
    ripgrep
    wget
    bat
    bottom
    btop
    eza
    fzf
    mpv
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
    xmousepasteblock
    zx
  ];

  # Services
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

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

    helix = {
      enable = true;
      defaultEditor = true;

      viAlias = true;
      vimAlias = true;
      nvimAlias = true;
    };
  };

  modules.services = {
    docker.enable = true;
  };

  # User Account
  user = {
    name = "levi";
    description = "Levi Manoel";

    groups = ["adbusers" "docker" "plugdev" "networking" "video" "wheel"];

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

    packages = with pkgs; let
      gcloud = google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
        gke-gcloud-auth-plugin
        kubectl
      ]);
    in [
      alejandra
      beekeeper-studio
      d2
      dbeaver
      discord
      dotnet-sdk_8
      flameshot
      gcloud
      gimp
      google-chrome
      gh
      gtk-engine-murrine
      nicotine-plus
      nil
      obsidian
      onlyoffice-bin
      qbittorrent
      spotify
      stremio
      sublime
      terraform
      ventoy-full
      vesktop
      vscode
      zed-editor
    ];

    home.programs = {
      vscode = {
        enable = true;
      };
    };

    sessionVariables = {
      GTK_THEME = "Gruvbox-Dark-B";
    };

    home.extraConfig = {      
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

        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };

        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };
    };
  };

  # environment.sessionVariables.DEFAULT_BROWSER = "${pkgs.google-chrome}/bin/google-chrome-stable";
  # xdg.mime = {
  #   enable = true;
  #   defaultApplications = {
  #     "text/html" = "org.qutebrowser.qutebrowser.desktop";
  #     "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
  #     "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
  #     "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
  #     "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
  #   };
  # };

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
