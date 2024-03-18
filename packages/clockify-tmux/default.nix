{
  pkgs,
  maxdots,
  lib,
  ...
}: let
  clockify-cli = pkgs.clockify-cli;

  interactive_start_timer = pkgs.writeShellScriptBin ''
    ${clockify-cli} in -i
  '';

  start_timer = pkgs.writeShellScriptBin ''
    function interactive_start_timer() {
      ${interactive_start_timer}
    }

    function clone_last_timer() {
      ${clockify-cli} clone last -i=0
    }

    function get_last_timer_end() {
      ${clockify-cli} show last -f '{{ .TimeInterval.End.Unix }}'
    }

    function start_timer() {
      last_timer_end = $(get_last_timer_end)
      now = $(date +%s)
      time_since_last_out = $((now - last_timer_end))

      # If less than an hour has passed since the last out, clone the last timer instead of starting a new one
      if [ $time_since_last_out -lt 3600 ]; then
        clone_last_timer
      else
        interactive_start_timer
      fi
    }
  '';

  stop_timer = pkgs.writeShellScriptBin ''
    ${clockify-cli} out
  '';

  toggle_timer = pkgs.writeShellScriptBin ''
    if ${clockify-cli} show current -q; then
      ${stop_timer}
    else
      ${start_timer}
    fi
  '';
in
  pkgs.mkTmuxPlugin {
    pluginName = "clockify";
    src = pkgs.writeTextFile {
      name = "clockify.tmux";
      text = ''
        #!/usr/bin/env bash
        # This tmux plugin provides a simple interface to the Clockify CLI
        # https://clockify.me/track-time/cli

        # Start a new timer
        bind-key C send-keys -t 0 "$(start_timer)" Enter
        bind-key c send-keys -t 0 "$(start_timer)" Enter

        # Stop the current timer
        bind-key X send-keys -t 0 "$(stop_timer)" Enter
        bind-key x send-keys -t 0 "$(stop_timer)" Enter

        # Toggle the current timer
        bind-key T send-keys -t 0 "$(toggle_timer)" Enter
        bind-key t send-keys -t 0 "$(toggle_timer)" Enter
      '';
      executable = true;
      destination = "/clockify.tmux";
    };
  }
