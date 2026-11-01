#!/bin/bash
# ClipStack helper. Usage: Tools/clipstack.sh build|run|install|update
set -euo pipefail
cd "$(dirname "$0")/.."

BUILD_DIR="$HOME/Library/Developer/ClipStack"
APP_NAME="ClipStack"

# Use the full Xcode even if xcode-select points at the command line tools.
if xcode-select -p 2>/dev/null | grep -q CommandLineTools; then
  export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
fi

build() {
  local config="$1"
  xcodebuild -project "$APP_NAME.xcodeproj" -scheme "$APP_NAME" \
    -configuration "$config" -derivedDataPath "$BUILD_DIR" \
    -destination "platform=macOS,arch=$(uname -m)" \
    -allowProvisioningUpdates -quiet build
  echo "$BUILD_DIR/Build/Products/$config/$APP_NAME.app"
}

quit_running() {
  osascript -e "quit app \"$APP_NAME\"" >/dev/null 2>&1 || true
  sleep 1
}

case "${1:-}" in
  build)
    build Debug
    ;;
  run)
    app=$(build Debug | tail -1)
    quit_running
    open "$app"
    ;;
  install)
    app=$(build Release | tail -1)
    quit_running
    rm -rf "/Applications/$APP_NAME.app"
    ditto "$app" "/Applications/$APP_NAME.app"
    open "/Applications/$APP_NAME.app"
    echo "Installed to /Applications/$APP_NAME.app"
    ;;
  update)
    git pull
    "$0" install
    ;;
  *)
    echo "Usage: Tools/clipstack.sh build|run|install|update"
    exit 1
    ;;
esac
