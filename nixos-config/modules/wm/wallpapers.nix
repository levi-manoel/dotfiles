{...}: {
  user.home = {
    programs = {
      wpaperd = {
        enable = true;
        settings = {
          default = {
            duration = "2m";
            path = "/home/levi/.dotfiles/nixos-config/wallpapers";
            sorting = "ascending";
            apply-shadow = false;
          };
        };
      };
    };
  };
}