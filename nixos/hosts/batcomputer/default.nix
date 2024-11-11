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
  };

  modules = {
    programs = {
      fish.enable = true;
      git.enable = true;
      kitty.enable = true;

      zed.enable = true;
    };

    services = {
      docker = {
        enable = true;
        compose = true;
      };

      stylix = {
        enable = true;
        wallpaper = wallpapers/bat2.png;
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
      (discord.override {withOpenASAR = true;})
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
      libreoffice-fresh
      minikube
      nil
      nixd
      obsidian
      obs-studio
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
      zx
    ];

    home = {
      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        google-chrome.enable = true;

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
