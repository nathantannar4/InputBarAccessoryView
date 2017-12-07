
Pod::Spec.new do |s|

    # 1 - Specs
    s.platform = :ios
    s.ios.deployment_target = '9.0'
    s.name = 'InputBarAccessoryView'
    s.summary = "Make powerful and flexible InputBars"
    s.description  = "A simple and highly customizable InputAccessoryView perfect for messaging applications."
    s.requires_arc = true
    s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

    # 2 - Version
    s.version = "1.4.3"

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

    # 8 - Source Files
    s.source_files = "InputBarAccessoryView/**/*.{swift}"

    # 9 - Resources

end
