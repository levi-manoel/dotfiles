{...}: {
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
}
