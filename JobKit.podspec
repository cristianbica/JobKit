Pod::Spec.new do |s|
  s.name             = "JobKit"
  s.version          = "0.1.0"
  s.summary          = "Pesistent job queueing for iOS."
  s.description      = <<-DESC
                       Pesistent job queueing for iOS backed by Realm.
                       DESC
  s.homepage         = "https://github.com/cristianbica/JobKit"
  s.license          = 'MIT'
  s.author           = { "Cristian Bica" => "cristian.bica@gmail.com" }
  s.source           = { :git => "https://github.com/cristianbica/JobKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/cristianbica'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'Realm'
end
