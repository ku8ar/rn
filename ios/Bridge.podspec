Pod::Spec.new do |s|
  s.name         = 'Bridge'
  s.version      = '1.0.0'
  s.summary      = 'Precompiled RN xcframework'
  s.description  = 'XCFramework with RCTRootView and main.jsbundle'
  s.homepage     = 'https://example.com'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'You' => 'you@example.com' }
  s.source       = { :path => '.' }

  s.platform     = :ios, '13.0'
  s.swift_version = '5.0'

  s.vendored_frameworks = 'output/Bridge.xcframework'

  s.module_name = 'Bridge'
  s.requires_arc = true

  # s.resources = ['output/BridgeResources.bundle/**/*']

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'CLANG_MODULES_AUTOLINK' => 'YES',
    'SWIFT_INCLUDE_PATHS' => '$(PODS_TARGET_SRCROOT)/output'
  }
end