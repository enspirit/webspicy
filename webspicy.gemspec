$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'webspicy/version'

Gem::Specification.new do |s|
  s.name        = 'webspicy'
  s.version     = Webspicy::VERSION
  s.date        = '2016-07-19'
  s.summary     = "Webspicy helps testing web services as software operation black boxes!"
  s.description = "Webspicy helps testing web services as software operation black boxes"
  s.authors     = ["Bernard Lambeau"]
  s.email       = 'blambeau@gmail.com'
  s.files       = Dir['LICENSE.md', 'Gemfile','Rakefile', '{bin,lib,spec,tasks,examples}/**/*', 'README*'] & `git ls-files -z`.split("\0")
  s.homepage    = 'http://github.com/enspirit/webspicy'
  s.license     = 'MIT'

  s.add_development_dependency "rake", "~> 10"
  s.add_development_dependency "sinatra", "~> 2.0"

  s.add_runtime_dependency "rspec", "~> 3.7"
  s.add_runtime_dependency "rack-test", "~> 0.6.3"
  s.add_runtime_dependency "finitio", ">= 0.5.2"
  s.add_runtime_dependency "http", "~> 2"
  s.add_runtime_dependency "path", "~> 1.3"
  s.add_runtime_dependency "rack-robustness", "~> 1.1.0"
end
