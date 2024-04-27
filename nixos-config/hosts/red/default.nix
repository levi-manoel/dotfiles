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

  # Packages
  environment.systemPackages = with pkgs; [
    #
    bind
    bintools
    coreutils
    curl
    file
    git
    git-crypt
    killall
    parted
    ripgrep
    wget

    bat
    bottom
    btop
    eza
    fzf
    mpv
    nitch
    tldr

    p7zip
    unrar
    unzip
    zip

    libnotify

    zx

    glib

    shfmt
    iwd
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Services
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
    # fish.enable = true;
    zsh.enable = true;

    git.enable = true;
    kitty.enable = true;

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

    groups = ["adbusers" "docker" "networking" "video" "wheel"];

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
    };

    packages = with pkgs; let
      gcloud = google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
        gke-gcloud-auth-plugin
        kubectl
      ]);
    in [
      alejandra
      d2
      dotnet-sdk_8
      flameshot
      gcloud
      google-chrome
      gh
      gtk-engine-murrine
      jetbrains.datagrip
      jetbrains.rider
      jetbrains.webstorm
      logseq
      minikube
      nicotine-plus
      nil
      obsidian
      onlyoffice-bin
      signal-desktop
      spotify
      stremio
      terraform
      tor-browser-bundle-bin
      ventoy-full
      vesktop
      vscode
    ];

    home.programs = {
      vscode = {
        enable = true;
      };
    };

    sessionVariables = {
      GTK_THEME = "Catppuccin-Mocha-Compact-Lavender-Dark";
    };

    home.extraConfig = {
      gtk = {
        enable = true;

        font = {
          name = "Zed Sans";
          size = 10;
        };

        theme = {
          name = "Catppuccin-Mocha-Compact-Lavender-Dark";
          package = pkgs.catppuccin-gtk.override {
            accents = ["lavender"];
            size = "compact";
            tweaks = ["rimless"];
            variant = "mocha";
          };
        };

        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.catppuccin-papirus-folders;
        };

        cursorTheme = {
          name = "Catppuccin-Mocha-Dark-Cursors";
          package = pkgs.catppuccin-cursors.mochaDark;
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
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
