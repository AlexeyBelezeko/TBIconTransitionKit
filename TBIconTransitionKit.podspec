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
  s.version          = "1.0.0"
  s.summary          = "Small kit, for animate your icon transition (like hamburger menu and arrow)."
  s.description      = <<-DESC
                       Small kit, for animate your icon transition (like hamburger menu and arrow).

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
