Pod::Spec.new do |s|
  s.name             = "Ripple"
  s.summary          = "Remember there's no such thing as a small act of kindness. Every act creates a ripple with no logical end."
  s.version          = "3.0"
  s.homepage         = "https://github.com/RamonGilabert/Ripple"
  s.license          = 'MIT'
  s.author           = { "Ramon Gilabert" => "ramon.gilabert.llop@gmail.com" }
  s.source           = {
    :git => "https://github.com/RamonGilabert/Ripple.git",
    :tag => s.version.to_s
  }
  s.social_media_url = 'https://twitter.com/RamonGilabert'

  s.ios.deployment_target = '8.0'

  s.requires_arc = true
  s.ios.source_files = 'Sources/**/*'
end
