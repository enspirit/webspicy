module Webspicy
  class Configuration

    LISTENER_KINDS = [ :before_all, :before_each, :after_all, :after_each, :around_each ]

    def initialize(folder = Path.pwd, parent = nil)
      @folder = folder
      @parent = parent
      @children = []
      @preconditions = []
      @postconditions = []
      @errconditions = []
      @listeners = Hash.new{|h,k| h[k] = [] }
      @rspec_options = default_rspec_options
      @run_examples = default_run_examples
      @run_counterexamples = default_run_counterexamples
      @run_generated_counterexamples = default_run_generated_counterexamples
      @file_filter = default_file_filter
      @service_filter = default_service_filter
      @test_case_filter = default_test_case_filter
      @colors = {
        :highlight => :cyan,
        :error => :red,
        :success => :green
      }
      @scope_factory = ->(config){ Scope.new(config) }
      @client = Web::HttpClient
      Path.require_tree(folder/'support') if (folder/'support').exists?
      yield(self) if block_given?
    end
    attr_accessor :folder
    protected :folder=

    attr_accessor :colors

    def self.dress(arg, &bl)
      case arg
      when Configuration
        arg
      when /^https?:\/\//
        Configuration.new{|c|
          c.scope_factory = SingleUrl.new(arg)
        }
      when ->(f){ Path(f).exists? }
        arg = Path(arg)
        if arg.file? && arg.ext == ".rb"
          c = Kernel.instance_eval arg.read, arg.to_s
          yield(c) if block_given?
          c
        elsif arg.file? && arg.ext == '.yml'
          folder = arg.backfind("[config.rb]")
          if folder && folder.exists?
            dress(folder/"config.rb"){|c|
              c.scope_factory = SingleYmlFile.new(arg)
            }
          else
            Configuration.new{|c|
              c.scope_factory = SingleYmlFile.new(arg)
            }
          end
        elsif arg.directory? and (arg/'config.rb').file?
          dress(arg/'config.rb', &bl)
        else
          raise ArgumentError, "Missing config.rb file"
        end
      else
        raise ArgumentError, "Unable to turn `#{arg}` to a configuration"
      end
    end

    def self.inherits(*args, &bl)
      dress(*args, &bl)
    end

    attr_accessor :parent
    protected :parent=

    def each_scope(&bl)
      return enum_for(:each_scope) unless block_given?
      if has_children?
        children.each do |config|
          config.each_scope(&bl)
        end
      else
        yield factor_scope
      end
    end

    attr_accessor :scope_factory

    def factor_scope
      @scope_factory.call(self)
    end

    # Adds a folder to the list of folders where test case definitions are
    # to be found.
    def folder(folder = nil, &bl)
      if folder.nil?
        @folder
      else
        folder = folder.is_a?(String) ? @folder/folder : Path(folder)
        raise "Folder `#{folder}` does not exists" unless folder.exists? && folder.directory?
        raise "Folder must be a descendant" unless folder.inside?(@folder)
        child = dup do |c|
          c.parent = self
          c.folder = folder
        end
        yield(child) if block_given?
        @children << child
        child
      end
    end
    attr_accessor :children
    protected :children=

    # Registers a precondition matcher
    def precondition(clazz)
      preconditions << clazz
    end
    attr_accessor :preconditions
    protected :preconditions=

    # Registers a postcondition matcher
    def postcondition(clazz)
      postconditions << clazz
    end
    attr_accessor :postconditions
    protected :postconditions=

    # Registers an errcondition matcher
    def errcondition(clazz)
      errconditions << clazz
    end
    attr_accessor :errconditions
    protected :errconditions=

    # Returns whether this configuration has children configurations or not
    def has_children?
      !children.empty?
    end

    # Sets whether examples have to be ran or not.
    def run_examples=(run_examples)
      @run_examples = run_examples
    end
    attr_reader :run_examples

    # Whether counter examples must be ran or not.
    def run_examples?
      @run_examples
    end

    # Returns the defaut value for run_examples
    def default_run_examples
      ENV['ROBUST'].nil? || (ENV['ROBUST'] != 'only' && ENV['ROBUST'] != 'generated')
    end
    private :default_run_examples

    # Sets whether counter examples have to be ran or not.
    def run_counterexamples=(run_counterexamples)
      @run_counterexamples = run_counterexamples
    end
    attr_reader :run_counterexamples

    # Whether counter examples must be ran or not.
    def run_counterexamples?
      @run_counterexamples
    end

    # Returns the defaut value for run_counterexamples
    def default_run_counterexamples
      ENV['ROBUST'].nil? || (ENV['ROBUST'] != 'no' && ENV['ROBUST'] != 'generated')
    end
    private :default_run_counterexamples

    # Sets whether generated counter examples have to be ran or not.
    def run_generated_counterexamples=(run_generated_counterexamples)
      @run_generated_counterexamples = run_generated_counterexamples
    end
    attr_reader :run_generated_counterexamples

    # Whether generated counter examples must be ran or not.
    def run_generated_counterexamples?
      @run_generated_counterexamples
    end

    # Returns the defaut value for run_generated_counterexamples
    def default_run_generated_counterexamples
      ENV['ROBUST'].nil? || (ENV['ROBUST'] != 'no')
    end
    private :default_run_generated_counterexamples

    # Installs a host (resolver).
    #
    # The host resolver is responsible from transforming URLs found in
    # .yml test files to an absolute URL invoked by the client. Supported
    # values are:
    #
    # - String: taken as a prefix for all relative URLs. Using this option
    #   lets specify all webservices through relative URLs and having the
    #   host itself as global configuration variable.
    # - Proc: all URLs are passed to the proc, relative and absolute ones.
    #   The result of the proc is used as URL to use in practice.
    #
    # When no host provider is provided, all URLs are expected to be absolute
    # URLs, otherwise an error will be thrown at runtime.
    def host=(host)
      @host = host
    end
    attr_reader :host

    # Installs a file filter.
    #
    # A file filter can be added to restrict the scope attention only to the
    # files that match the filter installed. Supported values are:
    #
    # - Proc: each file (a Path instance) is passed in turn. Only files for
    #   which a truthy value is returned will be considered by the scope.
    # - Regexp: the path of each file is matched against the regexp. Only files
    #   that match are considered by the scope.
    # - ===: any instance responding to `===` can be used as a matcher, following
    #   Ruby conventions. The match is done on a Path instance.
    #
    def file_filter=(file_filter)
      @file_filter = file_filter
    end
    attr_reader :file_filter

    # Returns the default file filter to use.
    #
    # By default no file filter is set, unless a RESOURCE environment variable is
    # set. In that case, a file filter is set that matches the file name to the
    # variable value, through a regular expression.
    def default_file_filter
      return nil unless res = ENV['RESOURCE']
      negated = res =~ /^!/
      rx = Regexp.compile(negated ? "#{res[1..-1]}" : res)
      negated ? ->(f){ !(f.to_s =~ rx) } : rx
    end
    private :default_file_filter

    # Installs a service filter.
    #
    # A service filter can be added to restrict the scope attention only to the
    # services that match the filter installed. Supported values are:
    #
    # - Proc: each service is passed in turn. Only services for which a truthy value
    #   is returned will be considered by the scope.
    # - ===: any instance responding to `===` can be used as a matcher, following
    #   Ruby conventions. The match is done on a Service instance.
    #
    def service_filter=(service_filter)
      @service_filter = service_filter
    end
    attr_reader :service_filter

    # Returns the default service filter.
    #
    # By default no filter is set unless a METHOD environment variable is set.
    # In that case, a service filter is returned that filters the services whose
    # HTTP method match the variable value.
    def default_service_filter
      ENV['METHOD'] ? ->(s){ s.method.to_s.downcase == ENV['METHOD'].downcase } : nil
    end
    private :default_service_filter

    # Installs a test case filter.
    #
    # A test case filter can be added to restrict the scope attention only to
    # the test cases that match the service installed. Supported values are:
    #
    # - Proc: each test case is passed in turn. Only test cases for which a
    # truthy value is returned will be considered by the scope.
    # - ===: any instance responding to `===` can be used as a matcher, following
    #   Ruby conventions. The match is done on a Service instance.
    def test_case_filter=(tag_filter)
      @test_case_filter = test_case_filter
    end
    attr_reader :test_case_filter

    # Returns the default test case filter.
    #
    # By default no filter is set unless a TAG environment variable is set.
    # In that case, a test case filter is returned that filters the test cases
    # whose tags map the specified value.
    def default_test_case_filter
      return nil unless tags = ENV['TAG']
      no, yes = tags.split(/\s*,\s*/).partition{|t| t =~ /^!/ }
      no, yes = no.map{|t| t[1..-1 ]}, yes
      ->(tc){
        (yes.empty? || !(yes & tc.tags).empty?) \
        && \
        (no.empty? || (no & tc.tags).empty?)
      }
    end

    # Installs a client class to use to invoke web services for real.
    #
    # This configuration allows defining a subclass of Client to be used for
    # actually invoking web services. Options are:
    #
    # - HttpClient: Uses the HTTP library to make real HTTP call to a web server.
    #
    # Note that this configuration variable expected a client *class*, not an
    # instance
    def client=(client)
      @client = client
    end
    attr_reader :client

    # Registers a listener under a given kind.
    def register_listener(kind, listener)
      raise "Must respond to call" unless listener.respond_to?(:call)
      @listeners[kind] << listener
    end
    private :register_listener

    # Returns the listeners of a specific kind.
    #
    # Recognized kinds are `before_each`, `after_each`, `before_all`, `after_all`
    # and `instrument`.
    def listeners(kind)
      @listeners[kind] || []
    end
    attr_writer :listeners
    protected :listeners=

    # Installs a listener that will be called before all tests
    #
    # The `listener` must respond to `call`.
    def before_all(l = nil, &listener)
      register_listener(:before_all, l || listener)
    end

    # Installs a listener that will be called before each web service invocation.
    #
    # The `listener` must respond to `call`.
    def before_each(l = nil, &listener)
      register_listener(:before_each, l || listener)
    end

    # Installs a listener that will be called after all tests
    #
    # The `listener` must respond to `call`.
    def after_all(l = nil, &listener)
      register_listener(:after_all, l || listener)
    end

    # Installs a listener that will be called after each web service invocation.
    #
    # The `listener` must respond to `call`.
    def after_each(l = nil, &listener)
      register_listener(:after_each, l || listener)
    end

    # Installs a listener that will be called around each web service invocation.
    #
    # The `listener` must respond to `call`.
    def around_each(l = nil, &listener)
      register_listener(:around_each, l || listener)
    end

    # Installs a listener that will be called right after all precondition
    # instrumentations.
    def instrument(&instrumentor)
      register_listener(:instrument, instrumentor)
    end

    # Allows setting the options passed at RSpec, which is used by both the runner
    # and checker classes.
    #
    # `options` is supposed to be valid RSpec options, to be passed at
    # `RSpec::Core::Runner.run`
    def rspec_options=(options)
      @rspec_options = options
    end
    attr_accessor :rspec_options
    protected :rspec_options=

    # Returns the default rspec options.
    #
    # By default rspec colors are enabled and the format set to 'documentation'.
    # The following environment variables <-> rspec options are supported:
    #
    # - FAILFAST <-> --fail-fast
    #
    def default_rspec_options
      dest_folder = (self.folder/'rspec.xml').to_s
      options = %w{--color --format=documentation --format RspecJunitFormatter --out} << dest_folder
      if ENV['FAILFAST']
        options << (ENV['FAILFAST'] == 'no' ? "--no-fail-fast" : "--fail-fast=#{ENV['FAILFAST']}")
      end
      options
    end
    private :default_rspec_options

    # Returns the Data system to use for parsing schemas
    #
    # The data system associated with a configuration is build when the
    # configuration folder contains a `schema.fio` finitio file. When no
    # such file can be found, the parent config is checked (if any). When
    # no `schema.fio` file can be found, the method ends up returning the
    # default Finition system.
    def data_system
      schema = self.folder/"schema.fio"
      if schema.file?
        Finitio.system(schema)
      elsif not(self.parent.nil?)
        self.parent.data_system
      else
        Webspicy::DEFAULT_SYSTEM
      end
    end

    # Returns the data generator to use, for generating random data when
    # needed.
    def generator
      @generator
    end
    attr_writer :generator

    # Duplicates this configuration and yields the block with the new one,
    # if a block is given.
    #
    # The cloned configuration has all same values as the original but shares
    # nothing with it. Therefore, affecting the new one has no effect on the
    # original.
    def dup(&bl)
      super.tap do |d|
        d.children = []
        d.preconditions = self.preconditions.dup
        d.postconditions = self.postconditions.dup
        d.errconditions = self.errconditions.dup
        d.rspec_options = self.rspec_options.dup
        d.listeners = LISTENER_KINDS.inject({}){|ls,kind|
          ls.merge(kind => self.listeners(kind).dup)
        }
        yield d if block_given?
      end
    end

  end
end
require_relative 'configuration/scope'
require_relative 'configuration/single_url'
require_relative 'configuration/single_yml_file'
