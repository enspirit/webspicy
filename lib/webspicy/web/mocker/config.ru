require "webspicy"
require "webspicy/web"
require "webspicy/web/mocker"
require 'rack'
config = Webspicy::Configuration.dress(Path("/formalspec/"))
run Webspicy::Web::Mocker.new(config)
