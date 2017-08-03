module Webspicy
  class Scope

    def initialize(config)
      @config = config
    end
    attr_reader :config

    def preconditions
      config.preconditions
    end

    def postconditions
      config.postconditions
    end

    ###
    ### Eachers -- Allow navigating the web service definitions
    ###

    # Yields each resource file in the current scope
    def each_resource_file(&bl)
      return enum_for(:each_resource_file) unless block_given?
      _each_resource_file(config, &bl)
    end

    # Recursive implementation of `each_resource_file` for each
    # folder in the configuration.
    def _each_resource_file(config)
      folder = config.folder
      folder.glob("**/*.yml").select(&to_filter_proc(config.file_filter)).each do |file|
        yield file, folder
      end
    end
    private :_each_resource_file

    # Yields each resource in the current scope in turn.
    def each_resource(&bl)
      return enum_for(:each_resource) unless block_given?
      each_resource_file do |file, folder|
        yield Webspicy.resource(file.load, file, self)
      end
    end

    def each_service(resource, &bl)
      resource.services.select(&to_filter_proc(config.service_filter)).each(&bl)
    end

    def each_example(service)
      service.examples.each{|s| yield(s, false) }
    end

    def each_counterexamples(service, &bl)
      service.counterexamples.each{|s| yield(s, true) } if config.run_counterexamples?
    end

    def each_generated_counterexamples(service, &bl)
      Webspicy.with_scope(self) do
        service.generated_counterexamples.each{|s| yield(s, true) }
      end if config.run_counterexamples?
    end

    def each_testcase(service, &bl)
      each_example(service, &bl)
      each_counterexamples(service, &bl)
      each_generated_counterexamples(service, &bl)
    end

    ###
    ### Schemas -- For parsing input and output data schemas found in
    ### web service definitions
    ###

    # Parses a Finitio schema based on the data system.
    def parse_schema(fio)
      data_system.parse(fio)
    end

    # Returns the Data system to use for parsing schemas
    def data_system
      @data_system ||= config.data_system
    end


    ###
    ### Service invocation: abstract the configuration about what client is
    ### used and how to instantiate it
    ###

    # Returns an instance of the client to use to invoke web services
    def get_client
      config.client.new(self)
    end

    # Convert an instantiated URL found in a webservice definition
    # to a real URL, using the configuration host.
    #
    # When no host resolved on the configuration and the url is not
    # already an absolute URL, yields the block if given, or raise
    # an exception.
    def to_real_url(url, &bl)
      case config.host
      when Proc
        config.host.call(url)
      when String
        url =~ /^http/ ? url : "#{config.host}#{url}"
      else
        return url if url =~ /^http/
        return yield(url) if block_given?
        raise "Unable to resolve `#{url}` : no host resolver provided\nSee `Configuration#host="
      end
    end

    ###
    ### Private methods
    ###

    private

      # Returns a proc that implements file_filter strategy according to the
      # type of filter installed
      def to_filter_proc(filter)
        case ff = filter
        when NilClass then ->(f){ true }
        when Proc     then ff
        when Regexp   then ->(f){ ff =~ f.to_s }
        else
          ->(f){ ff === f }
        end
      end

  end
end
