{
  self,
  writeShellScriptBin,
  symlinkJoin,
  lib,
  ...
}: let
  clockify-cli = "${self.clockify-cli}/bin/clockify-cli";
  runcached = lib.getExe self.runcached;

  defaultCachePath = "$HOME/.cache";
  defaultConfigPath = "$HOME/.clockify-cli.yaml";

  clockify-get-status = writeShellScriptBin "clockify-get-status" ''
    CONFIG_FILE="$1"
    TEMPLATE_STR="$2"

    [[ -z "$CONFIG_FILE" ]] && CONFIG_FILE="${defaultConfigPath}"
    [[ -z "$TEMPLATE_STR" ]] && TEMPLATE_STR="{{ .Project.ClientName }} 󰁕 {{ .Project.Name }}"

    function display_current_project() {
      ${clockify-cli} --config $CONFIG_FILE show current -f "$TEMPLATE_STR"
    }

    function display_current_duration() {
      ${clockify-cli} --config $CONFIG_FILE show current -D
    }

    function clockify_display() {
      project=$(display_current_project)

      if [ -z "$project" ]; then
        echo -n "Idle"
        return
      fi

      duration=$(display_current_duration)

      echo -n "$project | $duration"
    }

    clockify_display
  '';

  clockify-store-status = writeShellScriptBin "clockify-store-status" ''
    CONFIG_FILE="$1"
    CACHE_DIR="$2"
    TEMPLATE_STR="$3"

    [[ -z "$CONFIG_FILE" ]] && CONFIG_FILE="${defaultConfigPath}"
    [[ -z "$CACHE_DIR" ]] && CACHE_DIR="${defaultCachePath}"
    [[ ! -d "$CACHE_DIR" ]] && mkdir -p "$CACHE_DIR"

    CLOCKIFY_WATCH_CACHE_DIR="$CACHE_DIR/clockify-watch"

    status=$(${clockify-get-status}/bin/clockify-get-status "$CONFIG_FILE" "$TEMPLATE_STR")

    echo "Retrieved status from clockify: $status"
    echo "Writing status to $CLOCKIFY_WATCH_CACHE_DIR/status"

    echo "$status" > "$CLOCKIFY_WATCH_CACHE_DIR/status"

    [[ "$?" -eq 0 ]] && echo "Status stored successfully" || echo "Failed to store status"
  '';

  clockify-read-status = writeShellScriptBin "clockify-read-status" ''
    CONFIG_FILE="$1"
    CACHE_DIR="$2"
    TEMPLATE_DIR="$3"

    [[ -z "$CONFIG_FILE" ]] && CONFIG_FILE="${defaultConfigPath}"
    [[ -z "$CACHE_DIR" ]] && CACHE_DIR="${defaultCachePath}"

    CLOCKIFY_WATCH_CACHE_DIR="$CACHE_DIR/clockify-watch"
    RUNCACHED_CACHE_DIR="$CACHE_DIR/runcached"

    ## Temp solution: On Mac OS, simply run clockify-get-status in runcached mode
    if [ $(uname | grep -w Darwin) ]; then
      ${runcached} --ttl 5 --ignore-pwd --ignore-env --cache-dir $RUNCACHED_CACHE_DIR ${clockify-get-status} "$CONFIG_FILE" "$TEMPLATE_STR"
      exit 0
    else
      ## On Linux, we can safely rely on systemd
      cat "$CLOCKIFY_WATCH_CACHE_DIR/status"
    fi
  '';
in
  symlinkJoin {
    name = "clockify-watch";
    paths = [
      clockify-store-status
      clockify-read-status
    ];
  }
