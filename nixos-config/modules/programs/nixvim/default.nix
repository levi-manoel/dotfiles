{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.extra) mkEnableOption mkPackageOption mkBoolOption;

  cfg = config.modules.programs.nixvim;
in {
  options.modules.programs.nixvim = {
    enable = mkEnableOption "Enables nixvim";
    package = mkPackageOption pkgs.neovim-unwrapped "The neovim package to install";

    viAlias = mkBoolOption false "Symlink vi to nvim binary";
    vimAlias = mkBoolOption false "Symlink vim to nvim binary";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      inherit (cfg) enable package viAlias vimAlias;

      clipboard.providers.wl-copy.enable = true;

      plugins = { btw };

      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha";
          styles = {
            booleans = [
              "bold"
              "italic"
            ];
            conditionals = [
              "bold"
            ];
          };
        };
      };
    };
  };
}
