#
# Be sure to run `pod lib lint ReduxCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ReduxCore'
  s.version          = '1.0.0'
  s.summary          = 'Easy to use Redux abstractions for iOS projects'
  
  s.description      = "Redux abstractions for BetterMe projects and iOS community"

  s.homepage         = 'https://github.com/betterme-dev/ReduxCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BetterMe' => 'maksym.husar@betterme.world' }
  s.source           = { :git => 'https://github.com/betterme-dev/ReduxCore.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.watchos.deployment_target = '5.0'
  s.tvos.deployment_target = '12.0'
  s.swift_version = '5.1'

  s.source_files = 'ReduxCore/Sources/**/*.swift'
end
