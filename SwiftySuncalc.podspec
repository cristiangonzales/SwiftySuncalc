Pod::Spec.new do |s|
  s.name         = "SwiftySuncalc"
  s.version      = "1.0.0"
  s.summary      = "A Swift micro-library for finding sun and moon positions/phases."
  s.homepage     = "https://github.com/cristiangonzales/SwiftySuncalc"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Cristian Gonzales" => "xcristian.gonzales@gmail.com" }
  s.platform     = :ios, "11.0"
  s.source       = { :git => "https://github.com/cristiangonzales/SwiftySuncalc.git", :tag => "#{s.version}" }
  s.source_files = "SwiftySuncalc/**/*.{swift}"
  s.framework  = "Foundation"
  s.swift_version = "4.1"  
end
