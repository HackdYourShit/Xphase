require File.expand_path('../lib/xphase/gem_version', __FILE__)


Gem::Specification.new do |s|
    s.name               = 'xphase'
    s.version            = Xphase::VERSION

    s.date               = '2017-02-12'
    s.summary            = "Build phase manager for Xcode"
    s.description        = "It's like a package manager for your Xcode build phases."
    s.homepage           = 'https://github.com/CoreKit/xphase'
    s.license            = 'WTFPL'

    s.authors            = ["Tibor Bödecs"]
    s.email              = 'mail.tib@gmail.com'

    s.files              = Dir['lib/**/*.rb']
    s.executables        = %w( xphase )
    s.require_paths      = %w( lib )

    s.add_runtime_dependency 'xcodeproj',  '~> 1.4'

end