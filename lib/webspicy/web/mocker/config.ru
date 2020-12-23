require "webspicy"
require "webspicy/mocker"
require 'rack'
config = Webspicy::Configuration.dress(Path("/formalspec/"))
run Webspicy::Mocker.new(config)
