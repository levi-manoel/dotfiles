{
  pkgs,
  lib,
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
    bat
    btop
    cifs-utils
    coreutils
    curl
    eza
    fastfetch
    fzf
    git
    git-crypt
    gparted
    libnotify
    mpv
    nano
    nmap
    nomacs
    oh-my-posh
    p7zip
    parted
    pavucontrol
    playerctl
    tldr
    unrar
    unzip
    xclip
    wget
    wine
    zip
    zoxide
  ];

  # Services
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # need to change driver via cups after reboot (todo?)
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
    neovim = {
      enable = true;
      defaultEditor = false;

      viAlias = true;
      vimAlias = true;
    };
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  # User Account
  user = {
    name = "levi";
    description = "Levi Manoel";

    groups = ["adbusers" "avahi" "plugdev" "networking" "video" "wheel"];

    shellAliases = {
      ls = "exa";
      cat = "bat";

      gst = "git status";
      ga = "git add";
      gcmsg = "git commit -m";
      gp = "git push";
      gl = "git pull";
      gun = "git restore --staged";
      gcp = "git cherry-pick";
      gd = "git diff";
      gds = "git diff --staged";
      gsw = "git switch";

      irShell = "cd /home/levi/dev/irancho/sistema-irancho && nix develop --impure && cd -";
    };

    packages = with pkgs; [
      alejandra
      beekeeper-studio
      dbeaver-bin
      discord
      google-cloud-sdk
      gimp
      google-chrome
      gource
      gtk-engine-murrine
      kooha
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
      GTK_THEME = "Catppuccin-Mocha-Compact-Lavender-Dark";
    };

    home.extraConfig = {
      xsession = {
        pointerCursor = {
          name = "phinger-cursors-dark";
          package = pkgs.phinger-cursors;
          size = 24;
        };
      };

      gtk = {
        enable = true;

        font = {
          name = "Iosevka Comfy Motion";
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
}
