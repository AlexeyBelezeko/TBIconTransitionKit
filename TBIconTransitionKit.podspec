#
# Be sure to run `pod lib lint TBIconTransitionKit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TBIconTransitionKit"
  s.version          = "1.0.2"
  s.summary          = "TBIconTransitionKit is an easy to use icon transition kit that allows to smoothly change from one shape to another."
  s.description      = <<-DESC
                       TBIconTransitionKit is an easy to use icon transition kit that allows to smoothly change from one shape to another. Build on UIButton with CAShapeLayers It includes a set of the most common navigation icons. Feel free to recolor the them as you like and customise shapes — adjust the line spacing, edit the line width and it's cap.
                        * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/AlexeyBelezeko/TBIconTransitionKit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "AlexeyBelezeko" => "alexey.belezeko@sfcd.com" }
  s.source           = { :git => "https://github.com/AlexeyBelezeko/TBIconTransitionKit.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'TBIconTransitionKit' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
