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
    bind
    bintools
    bottom
    btop
    cifs-utils
    coreutils
    curl
    eza
    file
    fzf
    git
    git-crypt
    glib
    gparted
    killall
    libnotify
    mpv
    nano
    nitch
    nmap
    nomacs
    p7zip
    parted
    pavucontrol
    playerctl
    pv
    ripgrep
    shfmt
    tldr
    unrar
    unzip
    wget
    wine
    zip
    zoxide
    zx
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

  # slows down rebuild
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.guest.enable = true;

  # User Account
  user = {
    name = "levi";
    description = "Levi Manoel";

    groups = ["adbusers" "avahi" "docker" "plugdev" "networking" "vboxusers" "video" "wheel"];

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
      # fixes copy/paste bug
      dbeaver = pkgs.writeShellScriptBin "dbeaver" ''
        GDK_BACKEND=x11 ${pkgs.dbeaver}/bin/dbeaver
      '';
    in [
      alejandra
      beekeeper-studio
      d2
      dbeaver
      discord
      gimp
      google-chrome
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
}
