#
# Be sure to run `pod lib lint Pod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.swift_version    = '5.0'
  s.name             = 'FloatingLabelTextField'
  s.version          = '1.2.1'
  s.summary          = 'FloatingLabelTextField'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Library that allows to show animated floating label above the text field'

  s.homepage         = 'https://github.com/z-four/FloatingLabelTextField'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dmitriy Zhyzhko' => 'zfour.dev@gmail.com' }
  s.source           = { :git => 'https://github.com/z-four/FloatingLabelTextField.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

s.source_files = 'FloatingLabelTextField/Classes/**/*.swift'
#s.resource_bundles = {'FloatingLabelTextField' => ['FloatingLabelTextField/Classes/**/*']}
s.resource_bundle = { 'FloatingLabelTextField.swift' => 'FloatingLabelTextField/*.otf' }
#s.resources = "FloatingLabelTextField/**/*.{otf}"

end
