module Webspicy
  class Configuration

    def initialize(folder = Path.pwd)
      @folder = folder
      @children = []
      @before_listeners = []
      @rspec_options = default_rspec_options
      @run_counterexamples = default_run_counterexamples
      @file_filter = default_file_filter
      @service_filter = default_service_filter
      @client = HttpClient
      yield(self) if block_given?
    end
    attr_accessor :folder
    protected :folder=

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
          c.folder = folder
        end
        yield(child) if block_given?
        @children << child
        child
      end
    end
    attr_accessor :children
    protected :children=

    # Returns whether this configuration has children configurations or not
    def has_children?
      !children.empty?
    end

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
      ENV['ROBUST'].nil? || (ENV['ROBUST'] != 'no')
    end
    private :default_run_counterexamples

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
      ENV['RESOURCE'] ? Regexp.compile(ENV['RESOURCE']) : nil
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

    # Returns the default service filters.
    #
    # By default no filter is set unless a METHOD environment variable is set.
    # In that case, a service filter is returned that filters the services whose
    # HTTP method match the variable value.
    def default_service_filter
      ENV['METHOD'] ? ->(s){ s.method.to_s.downcase == ENV['METHOD'].downcase } : nil
    end
    private :default_service_filter


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

    # Installs a listener that will be called before each web service invocation.
    #
    # The `listener` must respond to `call`.
    def before_each(&listener)
      raise "Must respond to call" unless listener.respond_to?(:call)
      @before_listeners << listener
    end

    # Returns the list of listeners that must be called before each web service
    # invocation.
    def before_listeners
      @before_listeners
    end
    attr_writer :before_listeners
    protected :before_listeners=

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
      options = ["--color", "--format=documentation"]
      if ENV['FAILFAST']
        options << (ENV['FAILFAST'] == 'no' ? "--no-fail-fast" : "--fail-fast=#{ENV['FAILFAST']}")
      end
      options
    end
    private :default_rspec_options

    # Duplicates this configuration and yields the block with the new one,
    # if a block is given.
    #
    # The cloned configuration has all same values as the original but shares
    # nothing with it. Therefore, affecting the new one has no effect on the
    # original.
    def dup(&bl)
      super.tap do |d|
        d.children = self.children.dup
        d.rspec_options = self.rspec_options.dup
        d.before_listeners = self.before_listeners.dup
        yield d if block_given?
      end
    end

  end
end
