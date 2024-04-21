{
  pkgs,
  inputs,
  ...
}: {
  home.username = "levi";
  home.homeDirectory = "/home/levi";

  home.packages = with pkgs; [
    neofetch
    btop

    zip
    xz
    unzip
    p7zip

    cowsay
    file
    which
    tree
    gnupg

    pciutils # lspci
    usbutils # lsusb
  ];

  programs.git = {
    enable = true;
    userName = "levi-manoel";
    userEmail = "levimanoel.doeb@gmail.com";

    aliases = {
      st = "status";
      cmsg = "commit -m";

      unstage = "restore --staged";
      uncommit = "reset --soft HEAD~";

      cp = "cherry-pick";

      l = "log --oneline --no-merges";
      ll = "log --graph --topo-order --date=short --abbrev-commit --decorate --all --boundary --pretty=format:'%Cgreen%ad %Cred%h%Creset -%C(yellow)%d%Creset %s %Cblue[%cn]%Creset %Cblue%G?%Creset'";
      lll = "log --graph --topo-order --date=iso8601-strict --no-abbrev-commit --abbrev=40 --decorate --all --boundary --pretty=format:'%Cgreen%ad %Cred%h%Creset -%C(yellow)%d%Creset %s %Cblue[%cn <%ce>]%Creset %Cblue%G?%Creset'";

      save = "stash push -u";
      pop = "stash pop";
    };

    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.eol = "lf";
      core.editor = "nano";
      diff.algorithm = "histogram";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.default = "current";
      rebase.autoStash = true;

      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };

  programs.bash = {
    enable = true;

    bashrcExtra = "
      export XDG_DATA_HOME=\"$HOME/.local/share\"
      source /home/levi/dev/personal/scripts/git-prompt.sh

      function changes_in_branch() {
        if [ -d .git ] || [ -d ../.git ] || [ -d ../../.git ] || [ -d ../../../.git ] || [ -d ../../../../.git ]; then
        if expr length + \"$(git status -s)\" 2>&1 > /dev/null; then
          echo -ne \"\\033[0;33m$(__git_ps1)\\033[0m\";
        else
          echo -ne \"\\033[0;32m$(__git_ps1)\\033[0m\"; fi;
        fi
      }

      PS1=\"\\[\\033[0;32m\\]\\[\\033[0m\\033[0;32m\\]\\u\\[\\033[0;36m\\] @ \\[\\033[0;36m\\]\\h \\w\\[\\033[0;32m\\]$(__git_ps1)\\n\\[\\033[0;32m\\]└─\\[\\033[0m\\033[0;32m\\] \\$\\[\\033[0m\\033[0;32m\\] ▶\\[\\033[0m\\]  \"
    ";

    shellAliases = {
      dotfiles-sync = "cat /home/levi/dev/personal/dotfiles/nixos-config/flake.nix | sudo tee /etc/nixos/flake.nix && cat /home/levi/dev/personal/dotfiles/nixos-config/configuration.nix | sudo tee /etc/nixos/configuration.nix && cat /home/levi/dev/personal/dotfiles/nixos-config/home.nix | sudo tee /etc/nixos/home.nix";

      gst = "git status";
      ga = "git add";
      gcmsg = "git commit -m";
      gp = "git push";
      gl = "git pull";
      gunst = "git restore --staged";
      gcp = "git cherry-pick";
      gd = "git diff";
      gds = "git diff --staged";
    };
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
