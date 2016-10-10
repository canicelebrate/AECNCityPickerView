#
Pod::Spec.new do |s|
  s.name         = "AECNCityPickerView"
  s.version      = "0.0.2"
  s.summary      = "An China city picker by customizing UIPickerView for your iOS app."
  s.description  = "An easy to use and customizable pick city view component that presents a `UIPickerView` with a toolbar, Done button, animation, design options,."
  s.homepage     = "http://github.com/canicelebrate/AECNCityPickerView"
  s.screenshots  = "https://github.com/canicelebrate/AECNCityPickerView/blob/master/AECNCityPickerView.png?raw=true"
   s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "William Wang" => "canicelebrate@gmail.com" }
  s.source       = { :git => "https://github.com/canicelebrate/AECNCityPickerView.git", :tag => s.version }
  s.platform     = :ios, '6.0'
  s.source_files = 'AECNCityPickerView/*.{h,m}'
  s.resources = "AECNCityPickerView/Assets/*.xcassets"
  s.framework  = 'CoreGraphics'
  s.requires_arc = true
end
