require 'http'
require 'json'
require 'path'
require 'finitio'
require 'logger'
require 'ostruct'
require 'yaml'
require 'rack/test'
require 'mustermann'
require 'colorized_string'
require 'securerandom'
require 'forwardable'
module Webspicy

  ###
  ### Load library
  ###

  require 'webspicy/version'
  require 'webspicy/support'
  require 'webspicy/specification'
  require 'webspicy/configuration'
  require 'webspicy/tester'
  require 'webspicy/web'

  ###
  ### Backward compatibility
  ###
  Client = Tester::Client
  HttpClient = Web::HttpClient
  RackTestClient = Web::RackTestClient
  Resource = Specification
  Precondition = Specification::Precondition
  Postcondition = Specification::Postcondition
  FileUpload = Specification::FileUpload
  Scope = Configuration::Scope
  Checker = Tester::FileChecker

  ###
  ### About folders
  ###

  ROOT_FOLDER = Path.backfind('.[Gemfile]')

  EXAMPLES_FOLDER = ROOT_FOLDER/('examples')

  ###
  ### About formal doc and specifications defined there
  ###
  Finitio.stdlib_path(Path.dir/"finitio")
  DEFAULT_SYSTEM = Finitio.system(<<~FIO)
    @import webspicy/scalars
  FIO
  FORMALDOC = Finitio.system(Path.dir/("webspicy/formaldoc.fio"))

  ###
  ### Exceptions that we let pass during testing
  ###

  PASSTHROUGH_EXCEPTIONS = [NoMemoryError, SignalException, SystemExit]

  # Returns a default scope instance.
  def default_scope
    Configuration::Scope.new(Configuration.new)
  end
  module_function :default_scope

  def specification(raw, file = nil, scope = default_scope)
    raw = YAML.load(raw) if raw.is_a?(String)
    with_scope(scope) do
      r = FORMALDOC["Specification"].dress(raw)
      r.config = scope.config
      r.located_at!(file) if file
      r
    end
  rescue Finitio::Error => ex
    handle_finitio_error(ex, scope)
  end
  module_function :specification

  def service(raw, scope = default_scope)
    with_scope(scope) do
      FORMALDOC["Service"].dress(raw)
    end
  rescue Finitio::Error => ex
    handle_finitio_error(ex)
  end
  module_function :service

  def test_case(raw, scope = default_scope)
    with_scope(scope) do
      FORMALDOC["TestCase"].dress(raw)
    end
  rescue Finitio::Error => ex
    handle_finitio_error(ex)
  end
  module_function :test_case

  def handle_finitio_error(ex, scope)
    # msg = "#{ex.message}:\n    #{ex.root_cause.message}"
    # msg = Support::Colorize.colorize_error(msg, scope.config)
    # fatal(msg)
    raise
  end
  module_function :handle_finitio_error

  #
  # Yields the block after having installed `scope` globally.
  #
  # This method makes sure that the scope will also be accessible for
  # Finitio world schema parsing/dressing. Given that some global state
  # is required (see "Schema" ADT, the dresser in particular, which calls
  # `schema` later), the scope is put as a thread-local variable...
  #
  # This method is considered private and should not be used outside of
  # Webspicy itself.
  #
  def with_scope(scope)
    scope = set_current_scope(scope)
    result = yield scope
    set_current_scope(nil)
    result
  end
  module_function :with_scope

  #
  # Returns the current scope or a default one is none has been
  # previously installed using `set_current_scope` or `with_scope`
  #
  def current_scope
    Thread.current[:webspicy_scope] || default_scope
  end
  module_function :current_scope

  #
  # Sets the current scope.
  #
  # This method is considered private and should not be used outside of
  # Webspicy itself.
  #
  def set_current_scope(scope)
    Thread.current[:webspicy_scope] = scope
  end
  module_function :set_current_scope

  #
  # Parses a webservice schema (typically input or output) in the context
  # of the current scope previously installed using `with_scope`.
  #
  # If no scope has previously been installed, Finitio's default system
  # is used instead of another schema.
  #
  def schema(fio)
    if scope = Thread.current[:webspicy_scope]
      scope.parse_schema(fio)
    else
      DEFAULT_SYSTEM.system(fio)
    end
  end
  module_function :schema

  ###
  ### Logging facade
  ###

  LOGGER = ::Logger.new(STDOUT)
  LOGGER.level = Logger.const_get(ENV['LOG_LEVEL'] || 'WARN')
  LOGGER.formatter = proc { |severity, datetime, progname, msg|
    "  " + msg + "\n"
  }

  def info(*args, &bl)
    LOGGER && LOGGER.info(*args, &bl)
  end
  module_function :info

  def debug(*args, &bl)
    LOGGER && LOGGER.debug(*args, &bl)
  end
  module_function :debug

  def fatal(*args, &bl)
    LOGGER && LOGGER.fatal(*args, &bl)
  end
  module_function :fatal

end
