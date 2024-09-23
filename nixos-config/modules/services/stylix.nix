{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkForce mkIf;
  inherit (lib.extra) mkEnableOption mkPathOption;

  cfg = config.modules.services.stylix;
in {
  options.modules.services.stylix = {
    enable = mkEnableOption "Enables Stylix";
    wallpaper = mkPathOption "Wallpaper for Stylix to set";
  };

  config = mkIf cfg.enable {
    stylix = {
      inherit (cfg) enable;

      image = mkForce cfg.wallpaper;
      polarity = "dark";

      cursor = {
        name = "phinger-cursors-dark";
        package = pkgs.phinger-cursors;
        size = 24;
      };

      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      fonts = let
        noto-fonts = {
          name = "Noto Sans";
          package = pkgs.noto-fonts;
        };

        iosevka = {
          name = "Iosevka Comfy Motion";
          package = pkgs.iosevka-comfy.comfy-motion;
        };

        victor-mono = {
          name = "VictorMono NF";
          package = pkgs.nerdfonts;
        };
      in {
        sizes = {
          applications = 10;
          desktop = 10;
          popups = 10;
          terminal = 10;
        };

        serif = noto-fonts;
        sansSerif = victor-mono;
        monospace = victor-mono;
      };

      opacity = {
        terminal = 0.8;
      };

      targets = {
        chromium.enable = false;
      };
    };

    user.home.extraConfig = {
      gtk = {
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.catppuccin-papirus-folders;
        };
      };
    };
  };
}
