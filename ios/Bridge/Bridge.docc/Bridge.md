## Project Goal

This document outlines a clean and modular approach to integrating React Native (RN) code into a native iOS application. Instead of embedding RN directly within the iOS project, we build it as a standalone `XCFramework`. This decouples both codebases, simplifies dependency management, and speeds up native app compilation, all while preserving the flexibility and autonomy of the RN project.

## Overview

### ✅ Advantages
- The React Native app remains fully self-contained, independent of the host iOS implementation and its dependencies.
- Completely avoids dependency conflicts between RN and the iOS app.
- Significantly reduces native app build times.
- Encourages proper separation of responsibilities across teams and repositories.

### ⚠️ Drawbacks
- Some RN libraries may require additional handling in the `build-bridge.sh` script.
  - *Example:* Tracking libraries that compile native modules often require manual framework integration.

- Not all RN libraries work flawlessly in a precompiled setup.
  - *Example:* `react-native-reanimated` needs patching, although the workaround is straightforward.

- Adding multiple RN-based frameworks to the same iOS host can dramatically increase the final app size.
  - *Solution:* Extracting the Hermes binary (a major contributor to `.ipa` size) can help, but then all RN modules must share the same RN version.

---

## Xcode Project Setup

1. Create a new **Framework** target and name it `Bridge`.  
   *(This name is referenced in both `Bridge.podspec` and `build-bridge.sh`, so update those if you pick a different name.)*

2. Navigate to `Build Phases` → select the `Bridge` target → remove the phase **[CP] Copy Pods Resources**.  
   *(Frameworks cannot modify `Target Support Files` due to SIP restrictions.)*

3. Add the following files to the `Bridge` target:
   - `Bridge.h`
   - `BridgeWrapperViewController.h`
   - `BridgeWrapperViewController.m`
   - `RNBridgeViewController.swift`

   For each header file, set `Header Visibility` to **Public**.

---

## Source Code Configuration

### CocoaPods Setup in the React Native Project

To properly link React Native dependencies into the `Bridge` framework, you need to update the `Podfile` in your RN project by adding a dedicated target section. Insert the following into your `ios/Podfile`:

```ruby
target 'Bridge' do
  use_react_native!(
    :path => config[:reactNativePath],
    :app_path => "#{Pod::Config.instance.installation_root}/.."
  )
end
```

1. Copy the template implementation into `BridgeWrapperViewController.m`, and update `moduleName` to match your RN app.  
   *(You’ll find it in the RN project’s `AppDelegate.swift`.)*

2. Add these template files to your project:
   - `ios/Bridge/BridgeWrapperViewController.h`
   - `ios/Bridge/Bridge.h`
   - `ios/Bridge/RNBridgeViewController.swift`
   - `ios/build-bridge.sh`  
     *(Adjust the `WORKSPACE` variable to match your RN project name, found in `app.json`.)*

3. Add the `Bridge.podspec` template to `ios/`.  
   *(Be sure to personalize `version`, `homepage`, `author`, etc.)*

---

## Building the Framework

```bash
# From the project root:
npm install
cd ios
pod install
chmod +x build-bridge.sh
./build-bridge.sh
```

---

## What `build-bridge.sh` Does

- Archives the RN framework separately for device and simulator targets
- Combines both into a universal `XCFramework`

---

## Host App Integration

1. In your host app's `Podfile`, add:

```ruby
pod 'Bridge', :path => '../rn-project/ios' # Adjust the path if needed
```

2. Install the pod:

```bash
pod install
```

3. In `AppDelegate.swift`, declare the following property:

```swift
@objc var window: UIWindow?
```

4. Import the `Bridge` module wherever you need it:

```swift
import Bridge
```

5. Use the RN-powered view controller:

```swift
let vc = RNBridgeViewController()
...
```

---

## TODO
- Add support for passing input arguments to the RN module
- Implement output callbacks or communication back to the host app

---

## What's Next
- Code signing and notarization of the framework
- CI/CD integration to automate builds and releases

---

## Glossary

- **Bridge** — The framework target that packages the React Native app into an `XCFramework`.
- **Host** — The native iOS application that integrates one or more RN-powered modules.

