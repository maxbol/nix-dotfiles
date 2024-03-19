{
  pkgs,
  lib,
  self,
  ...
}:
with pkgs; let
  clockify = "${self.clockify-cli}/bin/clockify-cli";

  interactive_start_timer = writeShellScript "interactive_start_timer" ''
    ${clockify} in -i
  '';

  start_timer = writeShellScript "start_timer" ''
    function interactive_start_timer() {
      ${interactive_start_timer}
    }

    function clone_last_timer() {
      ${clockify} clone last -i=0
    }

    function get_last_timer_end() {
      ${clockify} show last -f '{{ .TimeInterval.End.Unix }}'
    }

    function start_timer() {
      last_timer_end=$(get_last_timer_end)
      now=$(date +%s)
      time_since_last_out=$((now - last_timer_end))

      # If less than an hour has passed since the last out, clone the last timer instead of starting a new one
      if [ $time_since_last_out -lt 3600 ]; then
        clone_last_timer
      else
        interactive_start_timer
      fi
    }

    start_timer
  '';

  toggle_timer = writeShellScript "toggle_timer" ''
    function start_timer() {
      ${start_timer}
    }

    function stop_timer() {
      ${clockify} out
    }

    if ${clockify} show current -q; then
      stop_timer
    else
      start_timer
    fi
  '';
in
  tmuxPlugins.mkTmuxPlugin {
    pluginName = "clockify";
    version = "20240318";
    src = writeTextFile {
      name = "clockify.tmux";
      text = ''
        #!/usr/bin/env bash
        # This tmux plugin provides a simple interface to the Clockify CLI
        # https://clockify.me/track-time/cli

        tmux_option_or_fallback() {
          local option_value
          option_value="$(tmux show-option -gqv "$1")"
          if [ -z "$option_value" ]; then
              option_value="$2"
          fi
          echo "$option_value"
        }

        # Start a new interactive timer in a popup
        tmux bind-key $(tmux_option_or_fallback "@clockify-bind-start" "C-v") display-popup -E -w 50% -h 50% "${interactive_start_timer}"

        # Start/stop timer
        tmux bind-key $(tmux_option_or_fallback "@clockify-bind-start" "v") display-popup -E -w 50% -h 50% "${toggle_timer}"
      '';
      executable = true;
      destination = "/clockify.tmux";
    };
  }
