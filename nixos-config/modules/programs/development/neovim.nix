{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit
    (lib.extra)
    mkBoolOption
    mkEnableOption
    ;

  cfg = config.modules.programs.neovim;
in {
  options.modules.programs.neovim = {
    enable = mkEnableOption "Enables the Neovim text editor.";
    defaultEditor = mkBoolOption false "Whether to configure nvim as the default editor using the EDITOR environment variable";

    viAlias = mkBoolOption false "Create alias for `vi`";
    vimAlias = mkBoolOption false "Create alias for `vim`";
  };

  config = {
    user.home.programs.neovim = {
      inherit (cfg) enable defaultEditor;
    };

    user.shellAliases = mkMerge [
      (mkIf cfg.viAlias {vi = "nvim";})
      (mkIf cfg.vimAlias {vim = "nvim";})
    ];
  };
}