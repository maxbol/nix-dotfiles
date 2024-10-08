{
  pkgs,
  lib,
  self,
  ...
}:
with pkgs; let
  clockify = "${self.clockify-cli}/bin/clockify-cli";

  store_project_id = writeShellScript "store_project_id" ''
    session_id=''${1:-NONE}
    project_id=''${2:-NONE}

    if [[ $session_id != "NONE" ]]; then
      session_path=~/.local/state/clockify-tmux/$session_id
      echo $project_id > $session_path
    fi
  '';

  interactive_start_timer = writeShellScript "interactive_start_timer" ''
    state_dir=~/.local/state/clockify-tmux
    mkdir -p $state_dir
    session_id=''${1:-NONE}

    ${clockify} in || exit 1
    pid=$(${clockify} show current -j | jq -r '.[0].projectId')
    ${store_project_id} $session_id $pid
  '';

  start_timer = writeShellScript "start_timer" ''
    state_dir=~/.local/state/clockify-tmux
    mkdir -p $state_dir

    session_id=''${1:-NONE}
    explicit_start=''${2:-0}
    project_id="NONE"

    if [[ -f $state_dir/$session_id ]]; then
      project_id=$(cat ~/.local/state/clockify-tmux/$session_id)
    fi

    function noninteractive_start_timer() {
      ${clockify} in -i=0 -j -p $project_id >/dev/null 2>&1
    }

    function clone_last_timer() {
      pid=$(${clockify} clone last -i=0 -j | jq -r '.[].projectId')
      store_project_id $pid
    }

    function get_last_timer_end() {
      ${clockify} show last -f '{{ .TimeInterval.End.Unix }}'
    }

    function start_timer() {
      if [[ $project_id != "NONE" ]]; then
        data=$(${clockify} show current -j)
        if [[ $? -eq 1 ]]; then
          if [[ $explicit_start -eq 0 ]]; then
            # Let's not start the timer automatically in these circumstances
            exit 0
          fi
          noninteractive_start_timer
        elif [[ $(echo "$data" | jq -r '.[0].projectId') != $project_id ]]; then
          noninteractive_start_timer
        fi
        exit 0
      fi

      if [[ $explicit_start -eq 0 ]]; then
        exit 0
      fi

      last_timer_end=$(get_last_timer_end)
      now=$(date +%s)
      time_since_last_out=$((now - last_timer_end))

      # If less than an hour has passed since the last out, clone the last timer instead of starting a new one
      if [ $time_since_last_out -lt 3600 ]; then
        clone_last_timer
      else
        ${interactive_start_timer}
      fi
    }

    start_timer
  '';

  toggle_timer = writeShellScript "toggle_timer" ''
    function start_timer() {
      ${start_timer} $*
    }

    function stop_timer() {
      ${clockify} out >/dev/null 2>&1
    }

    ${clockify} show current -q >/dev/null 2>&1 && stop_timer || start_timer $*
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
        tmux bind-key $(tmux_option_or_fallback "@clockify-bind-start" "C-v") display-popup -E -w 50% -h 50% '${interactive_start_timer} "$(tmux display-message -p "#S")" 1'

        # Start/stop timer
        tmux bind-key $(tmux_option_or_fallback "@clockify-bind-start" "v") display-popup -E -w 50% -h 50% '${toggle_timer} "$(tmux display-message -p "#S")" 1'

        # Auto start timer when session focused
        tmux set-hook -g pane-focus-in 'run-shell -b "${start_timer} #S 0 >/dev/null || true"'
      '';
      executable = true;
      destination = "/clockify.tmux";
    };
  }
