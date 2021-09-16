require "webspicy"
require "webspicy/web"
require "webspicy/web/inferer"
require 'logger'
require 'rack'
config = Webspicy::Configuration.dress(Path("/formalspec/"))
use Rack::CommonLogger, Logger.new(STDOUT)
run Webspicy::Web::Inferer.new(config)
