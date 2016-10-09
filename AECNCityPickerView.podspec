#
Pod::Spec.new do |s|
  s.name         = "AECNCityPickerView"
  s.version      = "0.0.1"
  s.summary      = "An China city picker by customizing UIPickerView for your iOS app."
  s.description  = "An easy to use and customizable pick city view component that presents a `UIPickerView` with a toolbar, Done button, animation, design options,."
  s.homepage     = "http://github.com/canicelebrate/AECNCityPickerView"
  s.screenshots  = "https://dl.dropboxusercontent.com/u/73895323/MMPickerView-GitHub.png"
  s.license      = 'MIT'
  s.author       = { "William Wang" => "canicelebrate@gmail.com" }
  s.source       = { :git => "https://github.com/canicelebrate/AECNCityPickerView.git", :tag => s.version }
  s.platform     = :ios, '9.0'
  s.source_files = 'AECNCityPickerView/*.{h,m}'
  s.framework  = 'CoreGraphics'
  s.requires_arc = true
end
