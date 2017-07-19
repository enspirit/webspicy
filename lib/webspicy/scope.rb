module Webspicy
  class Scope

    def initialize(config)
      @config = config
    end
    attr_reader :config

    # Yields each resource in the current scope in turn.
    def each_resource(&bl)
      config.folders.each do |folder|
        _each_resource(folder, &bl)
      end
    end

    # Recursive implementation of `each_resource` for each
    # folder in the configuration.
    def _each_resource(folder)
      folder.glob("**/*.yml") do |file|
        yield Webspicy.resource(file.load, file)
      end
    end
    private :_each_resource

    def each_service(resource, &bl)
      resource.services.each(&bl)
    end

    def each_example(service, &bl)
      service.examples.each(&bl)
    end

    def each_counterexamples(service, &bl)
      service.counterexamples.each(&bl)
    end

    # Parses a Finitio schema based on the data system.
    def parse_schema(fio)
      data_system.parse(fio)
    end

    # Returns the Data system to use for parsing schemas
    def data_system
      Finitio::DEFAULT_SYSTEM
    end

  end
end
