# Raycast Edge Profiles

Raycast commands that bring an already-open Microsoft Edge profile window forward, and launch that profile only when none is open.

`focus-edge-profile.sh` is the shared helper. Each profile is a small script next to it. `profile.template.sh` is the starting point for a new profile.

## What you do manually

1. Install [Raycast](https://www.raycast.com/) and Microsoft Edge.
2. Point each script at a profile directory whose name is also the name Edge puts on the window title. Edge does not do that on its own. See [Edge profile directories](#edge-profile-directories).
3. For a new profile, copy `profile.template.sh` to a new file in this directory and remove `.template.` from the filename. Raycast does not load scripts whose names contain `.template.`. Set `@raycast.title` to the command name you want to search for, and set `PROFILE` to the directory name. Keep the new script in this directory so it can source `focus-edge-profile.sh`.
4. Make the script executable:
  ```bash
   chmod +x your-profile.sh
  ```
5. Add this directory in Raycast once: open Settings, go to **Script Commands**, choose **Add Script Directory**, and select this folder. Raycast then detects new scripts in that same folder on its own, including another profile copied from the template. Metadata edits are picked up without a restart.
6. The first time a command runs, macOS asks for permission. Allow Raycast to control **System Events** and **Microsoft Edge** (System Settings → Privacy & Security → Automation). Inspecting Edge’s windows also needs Accessibility access for Raycast (System Settings → Privacy & Security → Accessibility).



## Edge profile directories

Profiles are folders under:

```text
~/Library/Application Support/Microsoft Edge/
```

Edge names them `Default`, then `Profile 1`, `Profile 2`, and so on. Quit Edge, then open that folder in Cursor and ask it to identify/rename each profile directory from the email domain stored in the profile. Set `PROFILE` in the script to the new directory name.

## How a command runs

Search for the command title in Raycast and press Return, or press the hotkey you assigned. Raycast runs the script in silent mode, so there is no Raycast window for the result.

The script calls `focus_edge_profile`. If Edge already has a window for that profile, the script brings it to the front. Until a second profile is open, Edge leaves the profile name off the window title; the helper treats those unmarked windows as belonging to the profile the Edge process was started with. If no window for the profile can be focused, the script starts Edge with `open -na "Microsoft Edge" --args --profile-directory="<PROFILE>"`, which opens that profile alongside any Edge window already on screen.

## Shortcuts

Hotkeys are global. They run the command even when Raycast is in the background.

1. Open Raycast and select the command (the `@raycast.title` value, for example `CMP` or `Evidi`).
2. Press **⌘K** and choose **Configure Command**, then **Set Hotkey**.
3. Press the key combination and confirm with **Return**.

You can review or change every assignment under Settings → **Shortcuts**. An optional alias is set the same way, with **Set Alias**, and then typed into Raycast search.

## Example: Evidi

Edge had stored the Evidi account in `~/Library/Application Support/Microsoft Edge/Default`. The signed-in email in that profile was on `evidi.com`.

1. Quit Edge. Open `~/Library/Application Support/Microsoft Edge/` in Cursor and ask it to rename each profile directory from the email domain in that profile. Cursor renames `Default` to `Evidi`.
2. Copy `profile.template.sh` to `evidi.sh` and set both the Raycast title and `PROFILE` to `Evidi`:
  ```bash
   # @raycast.title Evidi
   PROFILE="Evidi"
  ```
3. Make it executable with `chmod +x evidi.sh`.
4. If this folder is not a Raycast script directory yet, add it once under Settings → **Script Commands** → **Add Script Directory**. Later profiles in the same folder show up automatically. Allow Raycast to control System Events and Microsoft Edge when macOS asks.
5. In Raycast, select **Evidi**, press **⌘K**, choose **Configure Command** → **Set Hotkey**, and record a shortcut.

Pressing that shortcut runs `evidi.sh` in silent mode. If an Evidi window is already open, it comes to the front. Otherwise Edge launches with `--profile-directory=Evidi`. With another profile open, that window’s title ends in  `- Microsoft Edge - Evidi`.