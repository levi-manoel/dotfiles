{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.extra) mkEnableOption;

  cfg = config.modules.programs.zsh;
  kitty = config.modules.programs.kitty;
  starship = config.modules.programs.starship;
  user = config.user;
in {
  options.modules.programs.zsh = {
    enable = mkEnableOption "Enables Zsh shell";
  };

  config = {
    programs.zsh.enable = cfg.enable;
    user.shell = mkIf cfg.enable pkgs.zsh;

    user.home.programs.zsh = {
      inherit (cfg) enable;

      initExtra = "source /home/${config.user.name}/.dotfiles/.zshrc";

      completionInit = ''
        ${
          if kitty.enable
          then "set -g TERM xterm"
          else ""
        }

        ${
          if starship.enable
          then "eval \"$(starship init zsh)\""
          else ""
        }
      '';

      shellAliases = user.shellAliases;
    };
  };
}
