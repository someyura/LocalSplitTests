Pod::Spec.new do |s|
  s.name             = "LocalSplitTests"
  s.version          = "1.0"
  s.summary          = "Framework for implementing simple Split and A/B tests without a server."
  s.description      = "LocalSplitTests is a lightweight framework that allows you to implementing simple A/B tests without a server."
  s.homepage         = "https://github.com/someyura/LocalSplitTests"
  s.license          = 'MIT'
  s.author           = { "Yury Imashev" => "yuryimashev@gmail.com" }
  s.source           = { :git => "https://github.com/someyura/LocalSplitTests.git" }

  s.ios.deployment_target       = '9.0'
  s.osx.deployment_target       = '10.9'
  s.watchos.deployment_target   = '2.0'
  s.tvos.deployment_target      = '9.0'

  s.source_files      = 'Sources/**/*.swift', 'LocalSplitTests/*.{h,m}'
  s.requires_arc      = true
  s.swift_version     = '5.3.1'
end