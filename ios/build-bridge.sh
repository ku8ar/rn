#!/bin/bash

set -e

SCHEME="Bridge"
CONFIGURATION="Release"

BUILD_DIR="build"
OUTPUT_DIR="output"
FRAMEWORK_NAME="Bridge.framework"
XCWORKSPACE="rnbridge.xcworkspace"

REACT_NATIVE_CLI="../node_modules/react-native/cli.js"
LIB_HERMES_PATH_DEVICE="build/ios_devices.xcarchive/Products/usr/local/lib/libReact-hermes.a"
LIB_HERMES_PATH_SIMULATOR="build/ios_simulator.xcarchive/Products/usr/local/lib/libReact-hermes.a"

# Clean previous builds
# rm -rf "$BUILD_DIR"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# # Generate main.jsbundle
# echo "📦 Generating JS bundle (main.jsbundle)..."
node "$REACT_NATIVE_CLI" bundle \
  --platform ios \
  --dev false \
  --entry-file ./index.js \
  --bundle-output ./Bridge/main.jsbundle \
  --assets-dest ./Bridge

# echo "🧬 Generating React Native Codegen artifacts for Turbo Modules..."
pushd .. > /dev/null  
node ./node_modules/react-native/cli.js codegen
popd > /dev/null

# echo "📦 Building $SCHEME for device (iphoneos)..."
xcodebuild archive \
  -workspace "$XCWORKSPACE" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -sdk iphoneos \
  -destination "generic/platform=iOS" \
  -archivePath "$BUILD_DIR/ios_devices.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  OTHER_LDFLAGS="-ObjC -lc++"

#echo "📦 Building $SCHEME for simulator (iphonesimulator)..."
xcodebuild archive \
  -workspace "$XCWORKSPACE" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -sdk iphonesimulator \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$BUILD_DIR/ios_simulator.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  OTHER_LDFLAGS="-ObjC -lc++"

# mkdir -p "$OUTPUT_DIR/BridgeResources.bundle"
# cp Bridge/main.jsbundle "$OUTPUT_DIR/BridgeResources.bundle/"

#echo "🧱 Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "$BUILD_DIR/ios_devices.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME" \
  -framework "$BUILD_DIR/ios_simulator.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME" \
  -output "$OUTPUT_DIR/Bridge.xcframework"

echo "✅ Done! XCFramework is in $OUTPUT_DIR/Bridge.xcframework"
