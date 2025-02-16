{zathuraExe}: ''
  on activate_open_instance(quoted_win_title, unquoted_win_title, is_first_time)
    tell application "System Events"
      set zathuraProcList to a reference to (every process whose name is "zathura")
      repeat with proc in zathuraProcList
        set PID to proc's unix id
        -- I needed to figure out if this is the instance of Zathura with the
        -- file on hand. And if it is, then focus on that window. Guess what?
        -- Apparently you cannot grab list of all windows for a process (through
        -- "System Events") if that process has fullscreen windows. It just not
        -- possible. You have to do something like:
        -- `tell application "zathura"`
        -- alas, Zathura is not a "Cocoa Application"
        -- so I had to run lsof for the process PID and strip down the output to contain only filenames
        set myFiles to paragraphs of (do shell script "lsof -F -p " & PID & " | grep ^n/ | cut -c2-")
        -- have to use unquoted win title or comparison won't work
        if myFiles contains unquoted_win_title then
          tell proc
            set frontmost to true
          end tell
          return true
        end if
      end repeat
    end tell

    return false
  end activate_open_instance

  on single_run {single_input}
    set quoted_filePath to quoted form of POSIX path of single_input
    set unquoted_filePath to POSIX path of single_input
    -- first we try to find it (in case it's already opened)
    if not my activate_open_instance(quoted_filePath, unquoted_filePath, false) then
      -- set zathura to "${zathuraExe}"
      set zathura to (do shell script "which zathura")
      do shell script zathura & " " & quoted_filePath & " > /dev/null 2>&1 &"
      delay 0.8 -- delay is required so it can set the window to fullscreen, but until the window is created, you can't set its properties
      my activate_open_instance(quoted_filePath, unquoted_filePath, true)
    end if
  end single_run

  on run {input, parameters}
    set SelectedItems to input
    repeat with aFile in SelectedItems -- the loop through all selected items
        single_run(aFile)
    end repeat
  end run''
