#!/bin/bash
set -e

SRCROOT=$(pwd)

BUNDLE_NAME="index.android.bundle"
BRIDGE_DIR="bridge"
ASSETS_DIR="$SRCROOT/$BRIDGE_DIR/src/main/assets"
RES_DIR="$SRCROOT/$BRIDGE_DIR/src/main/res"

bundle_js() {
  echo "Bundling JS..."
  mkdir -p "$ASSETS_DIR"
  (cd "$SRCROOT/.." && npx react-native bundle \
    --platform android \
    --dev false \
    --entry-file index.js \
    --bundle-output "$ASSETS_DIR/$BUNDLE_NAME" \
    --assets-dest "$RES_DIR")
}

publish_native_modules() {
  echo "Finding native modules with build.gradle in node_modules..."
  find ../node_modules -type f -path "*/android/build.gradle" | while read -r gradlefile; do
    PKGDIR=$(dirname "$gradlefile")
    echo "Building and publishing: $PKGDIR"
    cd "$PKGDIR"
    if [ -f "./gradlew" ]; then
      ./gradlew publishToMavenLocal --quiet || echo "❌ Publish failed in $PKGDIR"
    else
      "$SRCROOT/../gradlew" -p "$PKGDIR" publishToMavenLocal --quiet || echo "❌ Publish failed in $PKGDIR"
    fi
    cd - > /dev/null
  done
}

publish_bridge() {
  echo "Building and publishing main bridge lib..."
  ./gradlew :bridge:publishToMavenLocal --quiet || echo "❌ Publish failed in $SRCROOT"
}

dev() {
  cd ..
  cd ..
  cd android
  ./gradlew installDebug
}

# bundle_js
# publish_native_modules
publish_bridge
dev
