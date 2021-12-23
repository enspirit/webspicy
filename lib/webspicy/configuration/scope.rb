module Webspicy
  class Configuration
    class Scope

      def initialize(config)
        @config = config
      end
      attr_reader :config

      ###
      ### Eachers -- Allow navigating the web service definitions
      ###

      # Yields each specification file in the current scope
      def each_specification_file(apply_filter = true, &bl)
        return enum_for(:each_specification_file, apply_filter) unless block_given?
        _each_specification_file(config, apply_filter, &bl)
      end

      # Recursive implementation of `each_specification_file` for each
      # folder in the configuration.
      def _each_specification_file(config, apply_filter = true)
        folder = config.folder
        world  = config.folder/"world"
        fs = folder.glob("**/*.{yml, yaml}").reject{|f| f.to_s.start_with?(world.to_s) }
        fs = fs.sort
        fs = fs.select(&to_filter_proc(config.file_filter)) if apply_filter
        fs.each do |file|
          yield file, folder
        end
      end
      private :_each_specification_file

      # Yields each specification in the current scope in turn.
      def each_specification(apply_filter = true, &bl)
        return enum_for(:each_specification, apply_filter) unless block_given?
        each_specification_file(apply_filter) do |file, folder|
          yield config.factory.specification(file.load, file, self)
        end
      end

      def each_service(specification, &bl)
        specification.services.select(&to_filter_proc(config.service_filter)).each(&bl)
      end

      def each_example(service, &bl)
        service.examples
          .map{|e| expand_example(service, e) }
          .select(&to_filter_proc(config.test_case_filter))
          .each(&bl) if config.run_examples?
      end

      def each_counterexamples(service, &bl)
        service.counterexamples
          .map{|e| expand_example(service, e) }
          .select(&to_filter_proc(config.test_case_filter))
          .each(&bl) if config.run_counterexamples?
      end

      def each_generated_counterexamples(service, &bl)
        Webspicy.with_scope(self) do
          service.generated_counterexamples
            .map{|e| expand_example(service, e) }
            .select(&to_filter_proc(config.test_case_filter))
            .each(&bl) if config.run_generated_counterexamples?
        end if config.run_generated_counterexamples?
      end

      def each_testcase(service, &bl)
        each_example(service, &bl)
        each_counterexamples(service, &bl)
        each_generated_counterexamples(service, &bl)
      end

      def find_test_case(method, url)
        each_specification(false) do |spec|
          next unless spec.url == url
          spec.services.each do |service|
            next unless service.method == method
            return service.examples.first
          end
        end
        nil
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
      def to_real_url(url, test_case = nil, &bl)
        case config.host
        when Proc
          config.host.call(url, test_case)
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

        def expand_example(service, example)
          return example unless service.default_example

          merged = Support::DeepMerge.deep_merge(
            service.default_example.to_info,
            example.to_info
          )
          ex = config.factory.test_case(merged, self)
          ex.bind(service, example.counterexample?)
        end

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

    end # class Scope
  end # class Configuration
end # module Webspicy
