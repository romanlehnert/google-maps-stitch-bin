Gem::Specification.new do |s|
  s.name        = 'google-maps-stitch-bin'
  s.version     = '0.1.3'
  s.date        = '2013-12-29'
  s.summary     = "Get images from google maps"
  s.description = ""
  s.authors     = ["Roman Lehnert"]
  s.email       = 'roman.lehnert@googlemail.com'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = ''
  s.license     = "MIT"
  s.add_development_dependency 'rspec', '~> 2.5'
  s.add_dependency 'rmagick', '~> 2.13'
  s.add_dependency 'pickled_optparse', '~> 0.1.1'
  s.add_dependency 'simple_mercator_location', '~> 1.0.0'
  s.test_files  = Dir.glob("{spec,test}/**/*.rb")
  s.executables = ["tiler"]
end
