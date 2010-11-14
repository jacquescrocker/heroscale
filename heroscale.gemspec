Gem::Specification.new do |s|
  s.name = "heroscale"
  s.version = "0.0.1"

  s.authors = ["Jacques Crocker"]
  s.summary = "Autoscale your heroku app"
  s.description = "Rack middleware that allows easy external querying of your heroku's app queue depth"

  s.email = "railsjedi@gmail.com"
  s.homepage = "http://github.com/railsjedi/heroscale"
  s.rubyforge_project = "none"

  s.require_paths = ["lib"]
  s.files = Dir['lib/**/*',
                'spec/**/*',
                'heroscale.gemspec',
                'Gemfile',
                'Gemfile.lock',
                'LICENSE',
                'Rakefile',
                'README.md']

  s.test_files = Dir['spec/**/*']
  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]

  s.add_development_dependency "json"
  s.add_development_dependency "rspec", "~> 2.0"
  s.add_development_dependency 'rake',      '~> 0.8.7'
end



