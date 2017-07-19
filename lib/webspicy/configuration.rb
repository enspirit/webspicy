module Webspicy
  class Configuration

    def initialize
      @folders = []
      @run_counterexamples = (ENV['ROBUST'].nil? || ENV['ROBUST'] != 'no')
      @file_filter = (ENV['RESOURCE'] ? Regexp.compile(ENV['RESOURCE']) : nil)
      @service_filter = (ENV['METHOD'] ? ->(s){ s.method.to_s.downcase == ENV['METHOD'].downcase } : nil)
      yield(self) if block_given?
    end

    # Adds a folder to the list of folders where test case definitions are
    # to be found.
    def add_folder(folder)
      folder = Path(folder)
      raise "Folder `#{folder}` does not exists" unless folder.exists? && folder.directory?
      @folders << folder
    end
    attr_reader :folders

    # Sets whether counter examples have to be ran or not.
    def run_counterexamples=(run_counterexamples)
      @run_counterexamples = run_counterexamples
    end
    attr_reader :run_counterexamples

    # Whether counter examples must be ran or not.
    def run_counterexamples?
      @run_counterexamples
    end

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

  end
end
