Pod::Spec.new do |spec|
  spec.name = "Ophiuchus"
  spec.version = "1.0.2"

  spec.homepage = "https://github.com/Yalantis/Preloader.Ophiuchus"
  spec.summary = "A custom Label consisted of CALayers of a sign which consist of CALayers of letters."

  spec.author = "Yalantis"
  spec.license = { :type => "MIT", :file => "LICENSE" }
  spec.social_media_url = "https://twitter.com/yalantis"

  spec.platform = :ios, '7.0'
  spec.ios.deployment_target = '7.0'

  spec.source = { :git => "git@github.com:Yalantis/Preloader.Ophiuchus.git", :tag => "1.0.2" }

  spec.requires_arc = true

  spec.source_files = 'Pod/Classes/**/*'
  spec.public_header_files = 'Pod/Classes/**/*.h'
  spec.frameworks = 'UIKit', 'CoreText'
  spec.requires_arc = true
end
