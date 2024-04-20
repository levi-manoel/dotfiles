{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Recife";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "br";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.levi = {
    isNormalUser = true;
    description = "levi";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      firefox
    ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    google-chrome
    vscode
    git
    discord
    vesktop
    dbeaver
    redis
    gnome.gnome-tweaks
    flameshot
    gparted
    stremio
    onlyoffice-bin
    alejandra
    nil
    nixpkgs-fmt
    gnome.dconf-editor

    nano
    curl
    wget
    tldr
    lshw
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  fonts = {
    fontDir.enable = true;

    enableDefaultPackages = true;

    packages = with pkgs; let
      mkZedFont = name: hash:
        stdenv.mkDerivation rec {
          inherit name;
          version = "1.2.0";

          src = fetchzip {
            inherit hash;

            url = "https://github.com/zed-industries/zed-fonts/releases/download/${version}/${name}-${version}.zip";
            stripRoot = false;
          };

          installPhase = ''
            runHook preInstall

            install -Dm644 *.ttf -t $out/share/fonts/truetype

            runHook postInstall
          '';
        };

      zed-mono = mkZedFont "zed-mono" "sha256-k9N9kWK2JvdDlGWgIKbRTcRLMyDfYdf3d3QTlA1iIEQ=";
      zed-sans = mkZedFont "zed-sans" "sha256-BF18dD0UE8Q4oDEcCf/mBkbmP6vCcB2vAodW6t+tocs=";
    in [
      victor-mono
      corefonts
      font-awesome
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese

      zed-mono
      zed-sans
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Victor Mono" "Zed Mono" "Noto Sans Mono"];
        serif = ["Noto Serif" "Source Han Serif"];
        sansSerif = ["Zed Sans" "Noto Sans" "Source Han Sans"];
      };
    };
  };

  # SERVICES
  services.redis.servers = {
    "redis" = {
      enable = true;
      port = 6379;
    };
  };

  system.stateVersion = "23.11";

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

  home-manager.users.levi = {pkgs, ...}: {
    programs.home-manager.enable = true;
    home.stateVersion = "23.11";
    home.username = "levi";
    home.homeDirectory = "/home/levi";

    programs.git = {
      enable = true;
      userName = "levi-manoel";
      userEmail = "levimanoel.doeb@gmail.com";

      aliases = {
        st = "status";
        cmsg = "commit -m";

        unstage = "restore --staged";
        uncommit = "reset --soft HEAD~";

        cp = "cherry-pick";

        l = "log --oneline --no-merges";
        ll = "log --graph --topo-order --date=short --abbrev-commit --decorate --all --boundary --pretty=format:'%Cgreen%ad %Cred%h%Creset -%C(yellow)%d%Creset %s %Cblue[%cn]%Creset %Cblue%G?%Creset'";
        lll = "log --graph --topo-order --date=iso8601-strict --no-abbrev-commit --abbrev=40 --decorate --all --boundary --pretty=format:'%Cgreen%ad %Cred%h%Creset -%C(yellow)%d%Creset %s %Cblue[%cn <%ce>]%Creset %Cblue%G?%Creset'";

        save = "stash push -u";
        pop = "stash pop";
      };

      extraConfig = {
        branch.autosetuprebase = "always";
        color.ui = true;
        core.eol = "lf";
        core.editor = "nano";
        diff.algorithm = "histogram";
        init.defaultBranch = "main";
        pull.rebase = true;
        push.default = "current";
        rebase.autoStash = true;

        url."git@github.com:".insteadOf = "https://github.com/";
      };
    };

    programs.bash = {
      enable = true;

      bashrcExtra = "
export XDG_DATA_HOME=\"$HOME/.local/share\"
source /home/levi/dev/personal/scripts/git-prompt.sh

function changes_in_branch() {
  if [ -d .git ] || [ -d ../.git ] || [ -d ../../.git ] || [ -d ../../../.git ] || [ -d ../../../../.git ]; then
  if expr length + \"$(git status -s)\" 2>&1 > /dev/null; then
    echo -ne \"\\033[0;33m$(__git_ps1)\\033[0m\";
  else
    echo -ne \"\\033[0;32m$(__git_ps1)\\033[0m\"; fi;
  fi
}

PS1=\"\\[\\033[0;32m\\]\\[\\033[0m\\033[0;32m\\]\\u\\[\\033[0;36m\\] @ \\[\\033[0;36m\\]\\h \\w\\[\\033[0;32m\\]$(__git_ps1)\\n\\[\\033[0;32m\\]└─\\[\\033[0m\\033[0;32m\\] \\$\\[\\033[0m\\033[0;32m\\] ▶\\[\\033[0m\\]  \"";

      shellAliases = {
        dotfiles-sync = "cat /home/levi/dev/personal/dotfiles/nixos-config/configuration.nix | sudo tee /etc/nixos/configuration.nix";

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
    };
  };

  # home-manager.users.levi = {
  #   dconf.settings = {
  #     "org/gnome/desktop/peripherals/touchpad" = {
  #       tap-to-click = true;
  #       two-finger-scrolling-enabled = true;
  #     };
  #   };

  #   "org/gnome/settings-daemon/plugins/media-keys" = {
  #     custom-keybindings = [
  #       "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
  #       "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
  #     ];
  #   };
  #   "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
  #     name = "Launch Terminal";
  #     command = "kgx";
  #     binding = "<Super>T";
  #   };

  #   "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
  #     name = "Launch Flameshot";
  #     command = "flameshot";
  #     binding = "<Super><Shift>S";
  #   };
  # };
}
