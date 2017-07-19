module Webspicy
  class Configuration

    def initialize
      @folders = []
      @run_counterexamples = (ENV['ROBUST'].nil? || ENV['ROBUST'] != 'no')
      yield(self) if block_given?
    end
    attr_reader   :folders
    attr_accessor :run_counterexamples

    # Adds a folder to the list of folders where test case definitions are
    # to be found.
    def add_folder(folder)
      folder = Path(folder)
      raise "Folder `#{folder}` does not exists" unless folder.exists? && folder.directory?
      @folders << folder
    end

    # Whether counter examples must be ran or not.
    def run_counterexamples?
      @run_counterexamples
    end

    # Returns the host (resolver) to use to convert relative URLs to
    # absolute ones.
    #
    # See `host=`
    def host
      @host
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

  end
end
