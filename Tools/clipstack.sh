#!/bin/bash
# ClipStack helper. Usage: Tools/clipstack.sh build|run|install|update|appstore
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
  appstore)
    # Builds the App Store version (sandboxed, copy only) and uploads it to App Store Connect.
    # Needs: your Apple ID added in Xcode > Settings > Accounts, and the app created in App Store Connect.
    archive="$BUILD_DIR/AppStore/$APP_NAME.xcarchive"
    rm -rf "$archive"
    xcodebuild -project "$APP_NAME.xcodeproj" -scheme "$APP_NAME" \
      -configuration AppStore -derivedDataPath "$BUILD_DIR" \
      -destination "generic/platform=macOS" \
      -archivePath "$archive" -allowProvisioningUpdates -quiet archive
    xcodebuild -exportArchive -archivePath "$archive" \
      -exportOptionsPlist Tools/AppStoreExport.plist \
      -exportPath "$BUILD_DIR/AppStore/Export" -allowProvisioningUpdates
    echo "Uploaded. In a few minutes it shows up in App Store Connect under TestFlight / Build."
    ;;
  *)
    echo "Usage: Tools/clipstack.sh build|run|install|update|appstore"
    exit 1
    ;;
esac
