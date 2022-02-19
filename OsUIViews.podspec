#
# Be sure to run `pod lib lint OsUIViews.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OsUIViews'
  s.version          = '0.5.8'
  s.summary          = 'This pod contains all of custom views used in osApps iOS apps'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  This pod contains all of open sourced custom views used in OsApps iOS apps
                       DESC
  
  # dependencies
  s.dependency 'youtube-ios-player-helper'
  s.dependency 'OsTools'
  
  s.homepage         = 'https://github.com/osfunapps/OsUIViews-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'osfunapps' => 'admin@os-apps.com' }
  s.source           = { :git => 'https://github.com/osfunapps/OsUIViews-iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_versions = "5.0"
  s.ios.deployment_target = '10.0'
  s.source_files = "Classes/**"
  
  
end
