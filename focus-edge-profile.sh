#!/bin/bash

# Bring forward an already-open Microsoft Edge window for a profile directory.
# Returns 0 when a window was focused, and 1 when the caller should launch Edge.
focus_edge_profile() {
  local profile="$1"
  local owns_unmarked="0"
  local result

  # Edge only appends the profile name to window titles after a second profile
  # is opened. Until then, every window belongs to the profile the process
  # was started with.
  if ps -axww -o command= | awk -v profile="$profile" '
    BEGIN { found = 0 }
    /\/MacOS\/Microsoft Edge / && !/Microsoft Edge Helper/ && !/ --type=/ {
      needle = "--profile-directory=" profile
      i = index($0, needle)
      if (i == 0) next
      after = substr($0, i + length(needle), 1)
      if (after == "" || after == " ") {
        found = 1
        exit
      }
    }
    END { exit (found ? 0 : 1) }
  '
  then
    owns_unmarked="1"
  fi

  result="$(osascript - "$profile" "$owns_unmarked" <<'EOF'
on run argv
  set profileName to item 1 of argv
  set ownsUnmarked to item 2 of argv
  set suffix to " - Microsoft Edge - " & profileName

  return my scan(suffix, ownsUnmarked)
end run

on scan(suffix, ownsUnmarked)
  if not my edgeIsRunning() then return "absent"

  set matchIndex to 0
  set windowIndex to 0
  set foundMarkedProfile to false
  set sawCompleteWindow to false

  tell application "System Events"
    tell process "Microsoft Edge"
      repeat with w in windows
        set windowIndex to windowIndex + 1
        set wname to ""
        try
          set wname to name of w as text
        end try
        if wname ends with suffix then
          set matchIndex to windowIndex
          exit repeat
        else if wname contains " - Microsoft Edge - " then
          set foundMarkedProfile to true
        else if wname contains "Microsoft Edge" then
          set sawCompleteWindow to true
        end if
      end repeat
    end tell
  end tell

  if matchIndex is greater than 0 then
    tell application "Microsoft Edge"
      set index of window matchIndex to 1
      activate
    end tell
    return "focused"
  end if

  if foundMarkedProfile or ownsUnmarked is not "1" or not sawCompleteWindow then return "missing"

  tell application "Microsoft Edge"
    if (count of windows) is 0 then return "missing"
    activate
  end tell
  return "focused"
end scan

on edgeIsRunning()
  tell application "System Events"
    return exists process "Microsoft Edge"
  end tell
end edgeIsRunning
EOF
)"

  [[ "$result" == "focused" ]]
}
