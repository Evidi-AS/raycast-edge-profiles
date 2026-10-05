#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Your Command Title
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🌐
# @raycast.packageName Microsoft Edge

# Copy this file next to focus-edge-profile.sh and remove ".template." from
# the filename. Raycast ignores scripts whose names contain ".template.".
# "Your Command Title" is the name you search for and bind a shortcut to.
# PROFILE is the Edge profile directory. It must also be the name Edge appends
# to the window title: " - Microsoft Edge - <PROFILE>".

PROFILE="Your Profile Directory"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=focus-edge-profile.sh
source "$SCRIPT_DIR/focus-edge-profile.sh"

if ! focus_edge_profile "$PROFILE"; then
  open -na "Microsoft Edge" --args --profile-directory="$PROFILE"
fi
