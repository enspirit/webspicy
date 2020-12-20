$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'webspicy/version'
require 'date'

Gem::Specification.new do |s|
  s.name        = 'webspicy'
  s.version     = Webspicy::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Webspicy helps testing web services as software operation black boxes!"
  s.description = "Webspicy helps testing web services as software operation black boxes"
  s.authors     = ["Bernard Lambeau"]
  s.email       = 'blambeau@gmail.com'
  s.files       = Dir['LICENSE.md', 'Gemfile','Rakefile', '{bin,lib,spec,tasks,examples}/**/*', 'README*'] & `git ls-files -z`.split("\0")
  s.homepage    = 'http://github.com/enspirit/webspicy'
  s.license     = 'MIT'

  s.bindir = "bin"
  s.executables = (Dir["bin/*"]).collect{|f| File.basename(f)}

  s.add_development_dependency "rake", "~> 12"
  s.add_development_dependency 'sinatra', '~> 2'

  s.add_runtime_dependency "rspec", "~> 3.10"
  s.add_runtime_dependency 'rspec_junit_formatter', '~> 0.4.1'
  s.add_runtime_dependency "rack-test", "~> 0.6.3"
  s.add_runtime_dependency 'finitio', '~> 0.9.0'
  s.add_runtime_dependency "http", ">= 2"
  s.add_runtime_dependency "path", "~> 2.0"
  s.add_runtime_dependency 'rack-robustness', '~> 1.1', '>= 1.1.0'
  s.add_runtime_dependency "mustermann", "~> 1.0"
  s.add_runtime_dependency "mustermann-contrib"
  s.add_runtime_dependency "colorize", "~> 0.8.1"
  s.add_runtime_dependency "openapi3_parser", "~> 0.8.2"
end
