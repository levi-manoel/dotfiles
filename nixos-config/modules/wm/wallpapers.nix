{...}: {
  user.home = {
    programs = {
      wpaperd = {
        enable = false;
        settings = {
          default = {
            duration = "2m";
            path = /home/levi/dev/personal/dotfiles/nixos-config/wallpapers;
            sorting = "ascending";
            apply-shadow = false;
          };
        };
      };
    };
  };
}