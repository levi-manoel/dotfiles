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
    coreutils
    curl
    exfat
    eza
    fastfetch
    file
    fzf
    git
    glib
    jq
    libnotify
    mpv
    # oh-my-posh
    openssl
    p7zip
    ripgrep
    tldr
    toybox
    unrar
    unzip
    wget
    zip
  ];

  # Services
  services = {
    gnome.gnome-keyring.enable = true;

    mysql = {
      enable = false;
      package = pkgs.mariadb;
    };

    redis.servers."redis" = {
      enable = true;
      port = 6379;
    };
  };

  programs = {
    adb.enable = true;
    command-not-found.enable = true;
  };

  modules = {
    programs = {
      fish.enable = true;
      zsh.enable = false;
      git.enable = true;
      kitty.enable = true;

      nixvim = {
        enable = true;

        viAlias = true;
        vimAlias = true;
      };

      zed.enable = true;
    };

    services = {
      docker = {
        enable = true;
        compose = true;
      };

      stylix = {
        enable = true;
        wallpaper = wallpapers/bat1.png;
      };
    };
  };

  # User Account
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
      d2
      dbeaver-bin
      devenv
      dotnet-sdk_8
      gcloud
      gimp
      gh
      kooha
      libreoffice-fresh
      minikube
      nil
      webcord
      nixd
      obsidian
      onlyoffice-bin
      shfmt
      signal-desktop
      spotify
      stremio
      tor-browser-bundle-bin
      ventoy-full
      # vscode.fhs
      zx
    ];

    home = {
      services.flameshot.enable = true;

      programs = {
        direnv = {
          enable = false;
          nix-direnv.enable = false;
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
