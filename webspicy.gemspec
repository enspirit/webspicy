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

  # Ruby 3.2 is what the newest dependencies require (finitio 1.0, http 6,
  # rack 3 through rack-robustness 2.0). Ruby 3.1 reached end of life in
  # March 2025.
  s.required_ruby_version = ">= 3.2"

  s.add_development_dependency "rake", "~> 13"
  s.add_development_dependency 'sinatra', '>= 4.0', '< 5.0'
  s.add_development_dependency "rspec", "~> 3.10"
  s.add_development_dependency 'rspec_junit_formatter', '>= 0.6', '< 0.7'

  # Webspicy sits between an application and its dependencies, so it holds
  # back everything it over-constrains. These ranges deliberately span two
  # major versions where one exists: which one an application runs on is its
  # call, not the test tool's.
  s.add_runtime_dependency 'finitio', '>= 0.12.2', '< 2.0'
  s.add_runtime_dependency "http", ">= 5.0", "< 7.0"
  s.add_runtime_dependency 'rack-robustness', '>= 1.2', '< 3.0'
  s.add_runtime_dependency "rack-proxy", ">= 0.7", "< 3.0"

  s.add_runtime_dependency "rack-test", ">= 2.0", "< 3.0"
  s.add_runtime_dependency "path", "~> 2.0"
  s.add_runtime_dependency "mustermann", ">= 3.0", "< 5.0"
  s.add_runtime_dependency "mustermann-contrib"
  s.add_runtime_dependency "paint", "~> 2.2"
  s.add_runtime_dependency "openapi3_parser", ">= 0.9", "< 0.11"
  s.add_runtime_dependency "mustache", "~> 1.0"
  s.add_runtime_dependency "mail", "~> 2.7"
  s.add_runtime_dependency "listen", "~> 3.7"
  s.add_runtime_dependency "predicate", ">= 2.8", "< 3.0"

  # Required by the library but no longer default gems, or about to stop
  # being ones. Declared explicitly rather than relying on the running Ruby
  # still bundling them.
  s.add_runtime_dependency "base64", ">= 0.2", "< 1.0"
  s.add_runtime_dependency "json", ">= 2.6", "< 4.0"
  s.add_runtime_dependency "logger", ">= 1.5", "< 2.0"
  s.add_runtime_dependency "ostruct", ">= 0.6", "< 1.0"
end
