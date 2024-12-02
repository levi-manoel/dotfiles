{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;

    enableDefaultPackages = true;

    packages = with pkgs; [
      corefonts
      font-awesome
      nerdfonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      source-han-sans

      monaspace
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Monaspace Krypton" "VictorMono NF" "Noto Sans Mono"];
        serif = ["Monaspace Xenon" "Source Han Serif"];
        sansSerif = ["Monaspace Krypton" "VictorMono NF" "Noto Sans" "Source Han Sans"];
      };
    };
  };
}
