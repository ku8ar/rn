#!/bin/bash

set -e

SCHEME="Bridge"
CONFIGURATION="Release"
BUILD_DIR="build"
OUTPUT_DIR="output"
FRAMEWORK_NAME="Bridge.framework"
XCWORKSPACE="rnbridge.xcworkspace"
REACT_NATIVE_CLI="../node_modules/react-native/cli.js"

# Clean previous builds
rm -rf "$BUILD_DIR"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# Generate main.jsbundle
echo "📦 Generating JS bundle (main.jsbundle)..."
node "$REACT_NATIVE_CLI" bundle \
  --platform ios \
  --dev false \
  --entry-file ./index.js \
  --bundle-output ./Bridge/main.jsbundle \
  --assets-dest ./Bridge

echo "📦 Building $SCHEME for device (iphoneos)..."
xcodebuild archive \
  -workspace "$XCWORKSPACE" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -sdk iphoneos \
  -destination "generic/platform=iOS" \
  -archivePath "$BUILD_DIR/ios_devices.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "🧪 Building $SCHEME for simulator (iphonesimulator)..."
xcodebuild archive \
  -workspace "$XCWORKSPACE" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -sdk iphonesimulator \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$BUILD_DIR/ios_simulator.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "🧱 Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "$BUILD_DIR/ios_devices.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME" \
  -framework "$BUILD_DIR/ios_simulator.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME" \
  -output "$OUTPUT_DIR/Bridge.xcframework"

echo "✅ Done! XCFramework is in $OUTPUT_DIR/Bridge.xcframework"
