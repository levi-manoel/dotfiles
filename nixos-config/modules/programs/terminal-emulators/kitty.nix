{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.extra) mkEnableOption;

  fish = config.modules.programs.fish;
  zsh = config.modules.programs.zsh;
  cfg = config.modules.programs.kitty;
in {
  options.modules.programs.kitty = {
    enable = mkEnableOption "Enables Kitty terminal emulator.";
  };

  config = mkIf cfg.enable {
    user.home.programs.kitty = {
      enable = true;

      settings = {
        copy_on_select = true;
        disable_ligatures = "cursor";
        enable_audio_bell = false;

        background_opacity = "0.9";
      };

      # TODO: use theming
      font = {
        name = "Zed Mono";
        size = 10.0;
      };

      theme = "Catppuccin-Mocha";

      shellIntegration.enableFishIntegration = fish.enable;
      shellIntegration.enableZshIntegration = zsh.enable;
    };
  };
}
