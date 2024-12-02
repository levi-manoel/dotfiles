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

      base16Scheme = ./github-dark.yaml;

      fonts = let
        monaspace-krypton = {
          name = "Monaspace Krypton";
          package = pkgs.monaspace;
        };

        monaspace-xenon = {
          name = "Monaspace Xenon";
          package = pkgs.monaspace;
        };
      in {
        sizes = {
          applications = 10;
          desktop = 10;
          popups = 10;
          terminal = 10;
        };

        serif = monaspace-xenon;
        sansSerif = monaspace-krypton;
        monospace = monaspace-krypton;
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
