#
# Be sure to run `pod lib lint WRMongolianKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WRMongolianKit'
  s.version          = '0.9.0'
  s.summary          = '竖向蒙文标签控件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '竖向蒙文标签控件，支持上下左右对齐，文本输入，警告控制器'

  s.homepage         = 'https://github.com/GodFighter/WRMongolianKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'GodFighter' => '{xianghui_ios@163.com}' }
  s.source           = { :git => 'https://github.com/GodFighter/WRMongolianKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.public_header_files = 'WRMongolianKit/WRMongolianKit.h'
  s.source_files = 'AFNetworking/AFNetworking.h'

  s.subspec 'CoreText' do |ss|
    ss.source_files = 'WRMongolianKit/Classes/CoreText/*.{h,m}'
  end

  s.subspec 'Input' do |ss|
    ss.source_files = 'WRMongolianKit/Classes/Input/*.{h,m}'
  end

  s.subspec 'Views' do |ss|
    ss.source_files = 'WRMongolianKit/Classes/Views/*.{h,m}'
    ss.public_header_files = 'WRMongolianKit/Classes/Views/*.h'

  s.subspec 'Controllers' do |ss|
    ss.source_files = 'WRMongolianKit/Classes/Controllers/*.{h,m}'
    ss.public_header_files = 'WRMongolianKit/Classes/Controllers/*.h'

  end


  # s.resource_bundles = {
  #   'WRMongolianKit' => ['WRMongolianKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
