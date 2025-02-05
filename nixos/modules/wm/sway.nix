{
  config,
  lib,
  pkgs,
  ...
}: let
  modifier = "Mod4";
  terminal = "${pkgs.kitty}/bin/kitty";
  menu = "${pkgs.rofi}/bin/rofi";

  left = "h";
  down = "j";
  up = "k";
  right = "l";

  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
      dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
    '';
  };

  configure-gtk = let
    gsettings = "${pkgs.glib}/bin/gsettings";
  in
    pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;

      text = ''
        CONFIG_FILE="/home/${config.user.name}/.config/gtk-3.0/settings.ini"

        if [ ! -f "$CONFIG_FILE" ]; then
          exit 1;
        fi

        GTK_THEME="$(grep 'gtk-theme-name' "$CONFIG_FILE" | sed 's/.*\s*=\s*//')"
        ICON_THEME="$(grep 'gtk-icon-theme-name' "$CONFIG_FILE" | sed 's/.*\s*=\s*//')"
        CURSOR_THEME="$(grep 'gtk-cursor-theme-name' "$CONFIG_FILE" | sed 's/.*\s*=\s*//')"
        FONT_NAME="$(grep 'gtk-font-name' "$CONFIG_FILE" | sed 's/.*\s*=\s*//')"

        ${gsettings} set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
        ${gsettings} set org.gnome.desktop.interface icon-theme "$ICON_THEME"
        ${gsettings} set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME"
        ${gsettings} set org.gnome.desktop.interface font-name "$FONT_NAME"

        ${gsettings} set org.gnome.desktop.interface color-scheme prefer-dark

        ${gsettings} set org.gnome.desktop.peripherals.keyboard remember-numlock-state true
      '';
    };
in {
  security.polkit.enable = true;

  programs.light.enable = true;
  programs.wshowkeys.enable = true;

  user.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";

    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "sway";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_CURRENT_SESSION = "sway";

    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    QT_QPA_PLATFORM = "wayland";
    # QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
  };

  environment.systemPackages = with pkgs; [
    configure-gtk
    dbus-sway-environment
    grim
    pcmanfm
    playerctl
    shotman
    slurp
    swaybg
    swaylock-effects
    wdisplays
    wl-clipboard
    wlr-randr
  ];

  user.home = {
    programs.rofi = {
      enable = true;
      terminal = terminal;
      # font = "Iosevka Comfy Motion 14";
      theme = let
        inherit (config.home-manager.users.${config.user.name}.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          width = 600;
        };

        "element-text, element-icon , mode-switcher" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        "window" = {
          height = mkLiteral "360px";
          border = mkLiteral "3px";
          border-color = mkLiteral "@background";
          background-color = mkLiteral "@background";
        };

        "mainbox" = {
          background-color = mkLiteral "@background";
        };

        "inputbar" = {
          children = mkLiteral "[prompt,entry]";
          background-color = mkLiteral "@background";
          border-radius = mkLiteral "5px";
          padding = mkLiteral "2px";
        };

        "prompt" = {
          background-color = mkLiteral "@blue";
          padding = mkLiteral "6px";
          text-color = lib.mkForce (mkLiteral "@selected-active-text");
          border-radius = mkLiteral "3px";
          margin = mkLiteral "20px 0px 0px 20px";
        };

        "textbox-prompt-colon" = {
          expand = false;
          str = "=";
        };

        "entry" = {
          padding = mkLiteral "6px";
          margin = mkLiteral "20px 0px 0px 10px";
          text-color = mkLiteral "@normal-text";
          background-color = mkLiteral "@background-color";
        };

        "listview" = {
          border = mkLiteral "0px 0px 0px";
          padding = mkLiteral "6px 0px 0px";
          margin = mkLiteral "10px 0px 0px 20px";
          columns = 2;
          lines = 5;
          background-color = mkLiteral "@background-color";
        };

        "element" = {
          padding = mkLiteral "5px";
          background-color = mkLiteral "@background-color";
          text-color = mkLiteral "@foreground";
        };

        "element-icon" = {
          size = mkLiteral "25px";
        };

        "element selected" = {
          background-color = lib.mkForce (mkLiteral "@blue");
          text-color = mkLiteral "@lightfg";
        };

        "mode-switcher" = {
          spacing = 0;
        };

        "button" = {
          padding = mkLiteral "10px";
          background-color = mkLiteral "@lightbg";
          text-color = mkLiteral "@normal-text";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.5";
        };

        "button selected" = {
          background-color = lib.mkForce (mkLiteral "@blue");
          text-color = lib.mkForce (mkLiteral "@selected-active-text");
        };

        "message" = {
          background-color = mkLiteral "@lightbg";
          margin = mkLiteral "2px";
          padding = mkLiteral "2px";
          border-radius = mkLiteral "5px";
        };

        "textbox" = {
          padding = mkLiteral "6px";
          margin = mkLiteral "20px 20px 0px 20px";
          text-color = mkLiteral "@base-text";
          background-color = mkLiteral "@lightbg";
        };
      };

      extraConfig = {
        modi = "run,drun,window";
        icon-theme = "Oranchelo";
        show-icons = true;
        drun-display-format = "{icon} {name}";
        location = 0;
        disable-history = false;
        hide-scrollbar = true;
        display-drun = "   Apps ";
        display-run = "   Run ";
        display-window = " 﩯 Window";
        display-Network = " 󰤨  Network";
        sidebar-mode = true;
      };
    };

    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        ignore-empty-password = true;

        font-size = 24;
        font = "Monaspace Krypton";

        clock = true;

        indicator-radius = 100;
        indicator-idle-visible = true;
        show-failed-attempts = true;
      };
    };

    programs.i3status-rust = {
      enable = true;
      bars = {
        bottom = {
          theme = "native";
          blocks = [
            {
              block = "memory";
              format = " $icon $mem_used_percents ";
              format_alt = " SWAP $swap_used_percents ";
            }
            {
              block = "cpu";
              interval = 1;
              format = " $barchart $utilization ";
            }
            {
              block = "sound";
              format = " $icon {$volume.eng(w:2) |}";
            }
            {
              block = "custom";
              command = "wpctl get-volume @DEFAULT_SOURCE@ | grep -q MUTED && echo [X] || echo [O]";
              interval = 1;
              click = [
                {
                  button = "left";
                  cmd = "wpctl set-mute @DEFAULT_SOURCE@ toggle";
                }
              ];
            }
            {
              block = "battery";
              device = "BAT0";
              format = " $icon $percentage $time $power ";
            }
            {
              block = "net";
              format = " $icon $ssid $signal_strength ";
              interval = 2;
            }
            {
              block = "custom";
              command = "warp-cli status | grep -q Connected && echo '>>' || echo '><'";
              interval = 1;
              click = [
                {
                  button = "left";
                  cmd = "warp-cli status | grep -q Connected && warp-cli disconnect || warp-cli connect";
                }
              ];
            }
            {
              block = "time";
              interval = 1;
              format = " $timestamp.datetime(f:'%F %T') ";
            }
          ];
        };
      };
    };

    services.mako = {
      enable = true;
      defaultTimeout = 10000;

      extraConfig = lib.mkForce ''
        background-color=#0d1117
        text-color=#c6cdd5
        border-color=#77bdfb
        progress-color=over #313244

        height=300
        width=400

        [urgency=high]
        border-color=#faa356
      '';
    };

    extraConfig.wayland.windowManager.sway = let
      theme = {
        base = "#0d1117"; # darkest bg
        surface0 = "#161b22"; # darker bg
        surface1 = "#21262d"; # dark bg
        text = "#89929b"; # muted text
        subtext0 = "#c6cdd5"; # bright text
        subtext1 = "#161b22"; # brightest text
        red = "#fa7970"; # error, deletion
        orange = "#faa356"; # warnings, changes
        green = "#7ce38b"; # success, addition
        blue = "#77bdfb"; # info, links
        lightblue = "#a2d2fb"; # selections
        purple = "#cea5fb"; # keywords, special
      };
    in {
      enable = true;
      package = pkgs.swayfx;

      checkConfig = false;

      wrapperFeatures.gtk = true;

      config = {
        modifier = modifier;
        terminal = terminal;

        bars = [
          {
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs $HOME/.config/i3status-rust/config-bottom.toml";
            colors = let
              mkColorSet = border: background: text: {inherit border background text;};
            in {
              background = theme.base;
              statusline = theme.text;
              focusedStatusline = theme.text;
              focusedSeparator = theme.surface1;
              focusedWorkspace = mkColorSet theme.base theme.base theme.blue;
              activeWorkspace = mkColorSet theme.base theme.base theme.blue;
              inactiveWorkspace = mkColorSet theme.base theme.base theme.surface1;
              urgentWorkspace = mkColorSet theme.base theme.base theme.surface1;
              bindingMode = mkColorSet theme.base theme.base theme.surface1;
            };
          }
        ];

        gaps = {
          inner = 15;
          smartGaps = true;
        };

        window = {
          titlebar = false;
          commands = let
            mkCmds = cmds: criteria:
              builtins.map (cmd: {
                inherit criteria;
                command = cmd;
              })
              cmds;
          in
            (mkCmds [
              "border pixel 0"
              "dim_inactive"
            ] {app_id = "^.*";})
            ++ [];
        };

        input = {
          "1:1:AT_Translated_Set_2_keyboard" = {
            "xkb_layout" = "br,us";
            "xkb_variant" = "abnt2,dvorak";
            "xkb_options" = "grp:alt_space_toggle";
          };

          "1133:49995:Logitech_USB_Keyboard" = {
            "xkb_layout" = "br,us";
            "xkb_variant" = "abnt2,dvorak";
            "xkb_options" = "grp:alt_space_toggle";
          };

          # swaymsg input type:touchpad events enabled/disabled
          "type:touchpad" = {
            "tap" = "enabled";
            "natural_scroll" = "enabled";
            "events" = "disabled_on_external_mouse";
          };
        };

        output."*".bg = "${config.stylix.image} fill";

        floating.criteria = [
          {app_id = ".blueman-manager-wrapped";}
          {app_id = "pcmanfm";}
        ];

        keybindings = {
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+q" = "kill";
          "${modifier}+space" = "exec ${menu} -show drun";
          "XF86Search" = "exec pcmanfm";

          "${modifier}+Shift+s" = "exec ${pkgs.shotman}/bin/shotman --capture region";

          "${modifier}+${left}" = "focus left";
          "${modifier}+${down}" = "focus down";
          "${modifier}+${up}" = "focus up";
          "${modifier}+${right}" = "focus right";

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          "${modifier}+Shift+${left}" = "move left";
          "${modifier}+Shift+${down}" = "move down";
          "${modifier}+Shift+${up}" = "move up";
          "${modifier}+Shift+${right}" = "move right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          "${modifier}+v" = "splitv";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+a" = "focus parent";

          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+Shift+space" = "floating toggle";
          # "${modifier}+space" = "focus mode_toggle";

          "${modifier}+period" = "workspace next";
          "${modifier}+comma" = "workspace prev";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";

          "${modifier}+Shift+period" = "move container to workspace next; workspace next";
          "${modifier}+Shift+comma" = "move container to workspace prev; workspace prev";

          "${modifier}+tab" = "workspace next_on_output";
          "Alt+tab" = "workspace back_and_forth";

          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";

          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          "${modifier}+r" = "mode resize";

          "${modifier}+b" = "exec playerctl pause && exec swaylock";

          "XF86MonBrightnessDown" = "exec light -U 10";
          "XF86MonBrightnessUp" = "exec light -A 10";

          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";

          "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1 @DEFAULT_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec wpctl set-volume -l 1 @DEFAULT_SINK@ 5%-";

          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_SOURCE@ toggle";
          "Alt+f5" = "exec wpctl set-mute @DEFAULT_SOURCE@ toggle";
        };
      };

      extraSessionCommands = ''
        eval $(gnome-keyring-daemon --start --components=secrets);
      '';

      extraConfig = ''
        # blur enable
        # corner_radius 6
        # shadows enable
        # default_dim_inactive 0.05
        # dim_inactive_colors.unfocused #000000FF
        # dim_inactive_colors.urgent ${theme.blue}

        client.focused          ${theme.blue}     ${theme.base} ${theme.subtext0}  ${theme.subtext0} ${theme.blue}
        client.focused_inactive ${theme.surface1} ${theme.base} ${theme.text}      ${theme.text}     ${theme.surface1}
        client.unfocused        ${theme.surface1} ${theme.base} ${theme.text}      ${theme.text}     ${theme.surface1}
        client.urgent           ${theme.orange}   ${theme.base} ${theme.orange}    ${theme.surface1} ${theme.orange}
        client.placeholder      ${theme.surface1} ${theme.base} ${theme.text}      ${theme.surface1} ${theme.surface1}
        client.background       ${theme.base}


        # Monitors
        set $PRIMARY "HDMI-A-1"
        set $FALLBACK "eDP-1"
        set $FALLBACKFALLBACK "eDP-2"

        workspace 1 output $PRIMARY $FALLBACK $FALLBACKFALLBACK
        workspace 2 output $PRIMARY $FALLBACK $FALLBACKFALLBACK
        workspace 3 output $PRIMARY $FALLBACK $FALLBACKFALLBACK
        workspace 4 output $PRIMARY $FALLBACK $FALLBACKFALLBACK
        workspace 5 output $FALLBACK $FALLBACKFALLBACK $PRIMARY
        workspace 6 output $PRIMARY $FALLBACK $FALLBACKFALLBACK
        workspace 7 output $PRIMARY $FALLBACK $FALLBACKFALLBACK
        workspace 8 output $FALLBACK $FALLBACKFALLBACK $PRIMARY
        workspace 9 output $FALLBACK $FALLBACKFALLBACK $PRIMARY

        # for_window [app_id="flameshot"] border pixel 0, floating enable, fullscreen disable, move absolute position 0 0

        exec dbus-sway-environment
        exec configure-gtk
      '';

      swaynag.enable = true;
    };
  };
}
