Pod::Spec.new do |s|
  s.name             = "JobKit"
  s.version          = "0.1.0"
  s.summary          = "Pesistent job queueing for iOS."
  s.description      = <<-DESC
                       Pesistent job queueing for iOS. Backed by Realm buy you can roll your own.
                       DESC
  s.homepage         = "https://github.com/cristianbica/JobKit"
  s.license          = 'MIT'
  s.author           = { "Cristian Bica" => "cristian.bica@gmail.com" }
  s.source           = { :git => "https://github.com/cristianbica/JobKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/cristianbica'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  #s.source_files = 'Pod/Classes/Core/JobKit.h'
  s.public_header_files = 'JobKit/**/*.h'

  s.subspec 'Core' do |ss|
    ss.source_files = 'JobKit/{Core,Jobs,Worker}/*.{h,m}'
  end

  s.subspec 'RealmAdapter' do |ss|
    ss.source_files = 'JobKit/Adapters/RealmAdapter/*.{h,m}'
    ss.dependency 'Realm'
  end

  s.subspec 'MemoryAdapter' do |ss|
    ss.source_files = 'JobKit/Adapters/MemoryAdapter/*.{h,m}'
  end
end
