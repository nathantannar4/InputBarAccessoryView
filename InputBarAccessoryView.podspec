
Pod::Spec.new do |s|

    # 1 - Specs
    s.platform = :ios
    s.ios.deployment_target = '12.0'
    s.name = 'InputBarAccessoryView'
    s.summary = "Make powerful and flexible InputAccessoryView's with ease"
    s.description  = "Featuring reactive changes, autocomplete, image paste support and so much more."
    s.requires_arc = true
    s.swift_versions = '5.3'

    # 2 - Version
    s.version = "5.2.1"

    # 3 - License
    s.license = { :type => "MIT", :file => "LICENSE" }

    # 4 - Author
    s.author = { "Nathan Tannar" => "nathantannar4@gmail.com" }

    # 5 - Homepage
    s.homepage = "https://github.com/nathantannar4/InputBarAccessoryView"

    # 6 - Source
    s.source = { :git => "https://github.com/nathantannar4/InputBarAccessoryView.git", :tag => "#{s.version}"}

    # 7 - Dependencies
    s.framework = "UIKit"

    # 8 - Sources
    s.default_subspec = 'Core'

    s.subspec 'Core' do |ss|
      ss.source_files = "Sources/**/*.{swift}"
    end

    s.subspec 'RxExtensions' do |ss|
      ss.source_files = "RxInputBarAccessoryView/*.{swift}"
      ss.dependency 'InputBarAccessoryView/Core'
      ss.dependency 'RxSwift'
      ss.dependency 'RxCocoa'
    end

end
