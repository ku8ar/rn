#!/bin/bash

set -euo pipefail

# Constants
export SRCROOT=$(pwd)
SCHEME="Bridge"
CONFIGURATION="Release"
WORKSPACE="rnbridge"
PROJECT="$SCHEME"
BUILD_DIR="$SRCROOT/build"
OUTPUT_DIR="$SRCROOT/output"
FRAMEWORK_NAME="$SCHEME.framework"
REACT_NATIVE_CLI="$SRCROOT/../node_modules/react-native/cli.js"

function init_directories() {
  rm -rf "$OUTPUT_DIR"
  mkdir -p "$OUTPUT_DIR"
  mkdir -p "$SRCROOT/Bridge"
}

function bundle_js() {
  node "$REACT_NATIVE_CLI" bundle \
    --platform ios \
    --dev false \
    --entry-file ./index.js \
    --bundle-output ./Bridge/main.jsbundle \
    --assets-dest ./Bridge
}

function run_codegen() {
  pushd "$SRCROOT/.." > /dev/null
  node ./node_modules/react-native/cli.js codegen
  popd > /dev/null
}

function archive() {
  local sdk=$1
  local destination=$2
  local archive_path=$3

  xcodebuild archive \
    -workspace "$WORKSPACE.xcworkspace" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -sdk "$sdk" \
    -destination "$destination" \
    -archivePath "$archive_path" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES
}

function create_xcframework() {
  xcodebuild -create-xcframework \
    -framework "$BUILD_DIR/ios_devices.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME" \
    -framework "$BUILD_DIR/ios_simulator.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME" \
    -output "$OUTPUT_DIR/Bridge.xcframework"
}

function build_bridge() {
  archive "iphoneos" "generic/platform=iOS" "$BUILD_DIR/ios_devices.xcarchive"
  archive "iphonesimulator" "generic/platform=iOS Simulator" "$BUILD_DIR/ios_simulator.xcarchive"
  create_xcframework
}

function copy_hermes() {
  cp -R "$SRCROOT/Pods/hermes-engine/destroot/Library/Frameworks/universal/hermes.xcframework" "$OUTPUT_DIR/hermes.xcframework"
}

function copy_resources() {
  mkdir -p "$OUTPUT_DIR/BridgeResources.bundle"
  cp Bridge/main.jsbundle "$OUTPUT_DIR/BridgeResources.bundle/"
}

init_directories
bundle_js
run_codegen
build_bridge
copy_hermes
copy_resources

echo "✅ Done! XCFramework is in $OUTPUT_DIR/Bridge.xcframework"
