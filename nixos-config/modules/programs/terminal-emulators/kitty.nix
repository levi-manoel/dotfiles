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
        window_padding_width = 10;

        background_opacity = "0.8";
      };

      font = {
        name = "VictorMono NF";
        size = 12.0;
      };

      theme = "Gruvbox Material Dark Hard";

      shellIntegration.enableFishIntegration = fish.enable;
      shellIntegration.enableZshIntegration = zsh.enable;
    };
  };
}
