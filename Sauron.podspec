#
# Be sure to run `pod lib lint Sauron.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Sauron'
  s.version          = '0.1.0'
  s.summary          = 'Network logging framework for iOS'

  s.description      = <<-DESC
  Logging network framework for iOS project, for debugging purposes
                       DESC

  s.homepage         = 'https://github.com/volatilegg/Sauron'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'volatilegg' => 'duc.fet01@gmail.com' }
  s.source           = { :git => 'https://github.com/volatilegg/Sauron.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/Volatilegg'
  s.ios.deployment_target = '14.0'
  s.swift_version = '5.0'
  s.source_files = 'Sources/Sauron/**/*'

end
