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
  s.files       = Dir['LICENSE.md', 'Gemfile','Rakefile', '{bin,doc,lib,spec,tasks}/**/*', 'README*']
  s.homepage    = 'http://github.com/enspirit/webspicy'
  s.license     = 'MIT'

  s.bindir = "bin"
  s.executables = (Dir["bin/*"]).collect{|f| File.basename(f)}

  s.add_development_dependency "rake", "~> 13"
  s.add_development_dependency 'sinatra', '> 3.0', '< 4.0'
  s.add_development_dependency "rspec", "~> 3.10"
  s.add_development_dependency 'rspec_junit_formatter', '>= 0.6', '< 0.7'

  s.add_runtime_dependency "rack-test", ">= 2.0", "< 3.0"
  s.add_runtime_dependency 'finitio', '>= 0.12.0', '< 0.13.0'
  s.add_runtime_dependency "http", ">= 5.0", "< 6.0"
  s.add_runtime_dependency "path", "~> 2.0"
  s.add_runtime_dependency 'rack-robustness', '>= 1.2', '< 2.0'
  s.add_runtime_dependency "mustermann", "~> 3.0"
  s.add_runtime_dependency "mustermann-contrib"
  s.add_runtime_dependency "paint", "~> 2.2"
  s.add_runtime_dependency "openapi3_parser", ">= 0.9", "< 0.10"
  s.add_runtime_dependency "mustache", "~> 1.0"
  s.add_runtime_dependency "mail", "~> 2.7"
  s.add_runtime_dependency "rack-proxy", "~> 0.7.0"
  s.add_runtime_dependency "listen", "~> 3.7"
  s.add_runtime_dependency "predicate", ">= 2.8", "< 3.0"
end
