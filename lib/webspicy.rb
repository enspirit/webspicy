require 'http'
require 'json'
require 'path'
require 'finitio'
require 'logger'
require 'ostruct'
require 'yaml'
module Webspicy

  ###
  ### Load library
  ###

  require 'webspicy/configuration'
  require 'webspicy/scope'
  require 'webspicy/runner'
  require 'webspicy/rest_client'
  require 'webspicy/resource'
  require 'webspicy/tester/assertions'
  require 'webspicy/tester/asserter'

  ###
  ### About folders
  ###

  ROOT_FOLDER = Path.backfind('.[Gemfile]')

  EXAMPLES_FOLDER = ROOT_FOLDER/'examples'

  ###
  ### About formal doc and resources defined there
  ###

  FORMALDOC = Finitio::DEFAULT_SYSTEM.parse (Path.dir/"webspicy/formaldoc.fio").read

  def resource(raw, file = nil)
    FORMALDOC["Resource"].dress(raw)
  end
  module_function :resource

  def service(raw)
    FORMALDOC["Service"].dress(raw)
  end
  module_function :service

  def test_case(raw)
    FORMALDOC["TestCase"].dress(raw)
  end
  module_function :test_case

  #
  # Yields a Scope instance for the configuration passed as parameter.
  #
  # This method makes sure that the scope will also be accessible for
  # Finitio world schema parsing/dressing. Given that some global state
  # is required (see "Schema" ADT, the dresser in particular, which calls
  # `schema` later), the scope is put as a thread-local variable...
  #
  def with_scope_for(config)
    scope = set_current_scope(Scope.new(config))
    yield scope
    set_current_scope(nil)
  end
  module_function :with_scope_for

  #
  # Sets the current scope.
  #
  # See `with_scope_for`
  #
  def set_current_scope(scope)
    Thread.current[:webspicy_scope] = scope
  end
  module_function :set_current_scope

  #
  # Parses a webservice schema (typically input or output) in the context
  # of the current scope previously installed using `with_scope_for`.
  #
  # If no scope has previously been installed, Finitio's default system
  # is used instead of another schema.
  #
  def schema(fio)
    if scope = Thread.current[:webspicy_scope]
      scope.parse_schema(fio)
    else
      Finitio::DEFAULT_SYSTEM.parse(fio)
    end
  end
  module_function :schema

  ###
  ### Logging facade
  ###

  LOGGER = ::Logger.new(STDOUT)
  LOGGER.level = Logger.const_get(ENV['LOG_LEVEL'] || 'WARN')

  def info(*args, &bl)
    LOGGER && LOGGER.info(*args, &bl)
  end
  module_function :info

  def debug(*args, &bl)
    LOGGER && LOGGER.debug(*args, &bl)
  end
  module_function :debug

end
