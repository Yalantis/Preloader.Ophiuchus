#
# Be sure to run `pod lib lint Ophiuchus.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Ophiuchus"
  s.version          = "0.1.0"
  s.summary          = "A custom Label consisted of CALayers of a sign which consist of CALayers of letters."
  s.description      = <<-DESC
                       An optional longer description of Ophiuchus

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/Yalantis/Ophiuchus"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Igor Muzyka" => "igor.muzyka@yalantis.com" }
  s.source           = { :git => "https://github.com/Yalantis/Ophiuchus.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'Ophiuchus' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'CoreText'
  # s.dependency 'AFNetworking', '~> 2.3'
end
