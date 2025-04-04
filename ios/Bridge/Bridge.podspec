Pod::Spec.new do |s|
  s.name             = 'Bridge'
  s.version          = '1.0.0'
  s.summary          = 'Precompiled React Native bridge module.'
  s.description      = 'Provides RNBridgeViewController and a bundled React Native runtime as an xcframework.'
  s.homepage         = 'https://example.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'YourName' => 'you@example.com' }

  # Use local path as source, assuming this podspec is inside ios/Bridge/
  s.source           = { :path => '.' }

  s.platform         = :ios, '13.0'
  s.swift_version    = '5.0'

  # Prebuilt xcframework that contains the compiled RN runtime and your code
  s.vendored_frameworks = 'Bridge.xcframework'

  # If you include bundled assets like main.jsbundle or images, you can expose them here
  # s.resource_bundles = {
  #   'BridgeResources' => ['Resources/**/*']
  # }
end