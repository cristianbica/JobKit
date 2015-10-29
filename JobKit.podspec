Pod::Spec.new do |s|
  s.name             = "JobKit"
  s.version          = "0.9.1"
  s.summary          = "Pesistent job queueing for iOS."
  s.description      = <<-DESC
                       Pesistent job queueing for iOS. Backed by Realm buy you can roll your own.
                       DESC
  s.homepage         = "https://github.com/cristianbica/JobKit"
  s.license          = 'MIT'
  s.author           = { "Cristian Bica" => "cristian.bica@gmail.com" }
  s.source           = { :git => "https://github.com/cristianbica/JobKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/cristianbica'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.requires_arc = true

  s.default_subspec = 'Core'

  s.subspec 'All' do |ss|
    ss.source_files = 'JobKit/**/*.{h,m}'
    ss.public_header_files = 'JobKit/**/*.h'
    ss.resources = 'JobKit/Adapters/CoreDataAdapter/*.{xcdatamodeld,xcdatamodel}'
    ss.dependency 'Realm'
    ss.frameworks = 'CoreData'
  end

  s.subspec 'Core' do |ss|
    ss.source_files = 'JobKit/{Core,Jobs,Worker}/*.{h,m}'
  end

  s.subspec 'Realm' do |ss|
    ss.source_files = 'JobKit/Adapters/RealmAdapter/*.{h,m}'
    ss.dependency 'Realm'
    ss.dependency 'JobKit/Core'
  end

  s.subspec 'Memory' do |ss|
    ss.source_files = 'JobKit/Adapters/MemoryAdapter/*.{h,m}'
    ss.dependency 'JobKit/Core'
  end

  s.subspec 'CoreData' do |ss|
    ss.resources = 'JobKit/Adapters/CoreDataAdapter/*.{xcdatamodeld,xcdatamodel}'
    ss.source_files = 'JobKit/Adapters/CoreDataAdapter/*.{h,m}'
    ss.frameworks = 'CoreData'
    ss.dependency 'JobKit/Core'
  end

  s.subspec 'Headers' do |ss|
    ss.source_files = 'JobKit/**/*.h'
    ss.public_header_files = 'JobKit/**/*.h'
  end

end
