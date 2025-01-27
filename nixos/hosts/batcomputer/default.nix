{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware.nix
  ];

  environment.systemPackages = with pkgs; [
    arion
    bat
    bintools
    bottom
    btop
    cloudflare-warp
    coreutils
    curl
    exfat
    eza
    fastfetch
    file
    fzf
    gcc
    git
    glib
    gnumake
    gparted
    jdk8
    jq
    libinput
    libnotify
    mangohud
    mpv
    openssl
    p7zip
    ripgrep
    stow
    tldr
    toybox
    unrar
    unzip
    wget
    xclicker
    zip
  ];

  # programs.steam.enable = true;
  # programs.steam.gamescopeSession.enable = true;
  # programs.gamemode.enable = true;

  services = {
    gnome.gnome-keyring.enable = true;

    redis.servers."redis" = {
      enable = true;
      port = 6379;
    };

    # xserver.enable = true;
    # xserver.displayManager.gdm.enable = true;
    # xserver.desktopManager.gnome.enable = true;
  };

  # environment.gnome.excludePackages = with pkgs; [
  #   gnome-tour
  #   gnome-connections
  #   epiphany
  #   geary
  #   evince
  # ];

  modules = {
    programs = {
      fish.enable = true;
      git.enable = true;
      kitty.enable = true;
    };

    services = {
      docker = {
        enable = true;
        compose = true;
      };

      stylix = {
        enable = true;
        wallpaper = wallpapers/bat1.jpg;
      };
    };
  };

  user = {
    name = "levi";
    description = "Levi Manoel";

    groups = ["adbusers" "docker" "networking" "video" "wheel" "kvm" "dialout"];

    shellAliases = {
      ls = "exa";
      cat = "bat";

      gst = "git status";
      gsw = "git switch";
      gco = "git checkout";
      ga = "git add";
      gc = "git commit";
      gcm = "git commit -m";
      gd = "git diff";
      gds = "git diff --staged";
      gl = "git pull";
      gp = "git push";
    };

    packages = with pkgs; let
      gcloud = google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
        gke-gcloud-auth-plugin
        kubectl
      ]);
    in [
      alejandra
      anydesk
      beekeeper-studio
      chromium
      d2
      dbeaver-bin
      devenv
      dotnet-sdk_8
      gcloud
      gimp
      gh
      klavaro
      kooha
      # libreoffice-fresh
      minikube
      nil
      nixd
      obsidian
      onlyoffice-bin
      presenterm
      prismlauncher
      protonup
      qbittorrent
      shfmt
      signal-desktop
      slack
      spotify
      stremio
      tor-browser-bundle-bin
      ventoy-full
      vesktop
      warp-terminal
      wpsoffice
      zx
    ];

    home = {
      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        google-chrome.enable = true;

        obs-studio = {
          enable = true;
          plugins = with pkgs.obs-studio-plugins; [
            wlrobs
            obs-backgroundremoval
            obs-pipewire-audio-capture
          ];
        };

        tmux = {
          enable = true;

          mouse = true;
          extraConfig = ''
            set -g history-limit 50000
            set -g display-time 4000
            set -g status-interval 5
            set -g focus-events on
            set -g aggressive-resize on
            set -g base-index 1
            setw -g pane-base-index 1
          '';
        };

        vscode = {
          enable = true;
          package = pkgs.vscode.fhs;

          extensions = lib.mkForce [];
          userSettings = lib.mkForce {};
        };
      };
    };
  };
}
