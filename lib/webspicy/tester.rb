module Webspicy
  class Tester

    def initialize(config)
      @config = Configuration.dress(config)
      @scope = nil
      @client = nil
      @spec_file = nil
      @specification = nil
      @service = nil
      @test_case = nil
      @invocation = nil
      @reporter = default_reporter
    end
    attr_reader :config, :scope, :client
    attr_reader :specification, :spec_file
    attr_reader :service, :test_case
    attr_reader :invocation, :result
    attr_reader :reporter

    def default_reporter
      @reporter = Reporter::Composite.new
      #@reporter << Reporter::Progress.new
      @reporter << Reporter::Documentation.new
      @reporter << Reporter::Exceptions.new
      @reporter << Reporter::Summary.new
    end

    def call
      reporter.init(self)
      before_all
      run_config
      after_all
      reporter.report
    end

  private

    def before_all
      reporter.before_all
      config.listeners(:before_all).each do |l|
        l.call(config)
      end
      reporter.before_all_done
    end

    def run_config
      config.each_scope do |scope|
        @scope = scope
        @client = scope.get_client
        reporter.before_scope
        run_scope
        reporter.scope_done
      end
    end

    def run_scope
      scope.each_specification_file do |spec_file|
        @specification = load_specification(spec_file)
        if @specification
          reporter.before_specification
          run_specification
          reporter.specification_done
          reporter.spec_file_done
        end
      end
    end

    def load_specification(spec_file)
      @spec_file = spec_file
      reporter.before_spec_file
      Webspicy.specification(spec_file.load, spec_file, scope)
    rescue *PASSTHROUGH_EXCEPTIONS
      raise
    rescue Exception => e
      reporter.spec_file_error(e)
      nil
    end

    def run_specification
      scope.each_service(specification) do |service|
        @service = service
        reporter.before_service
        run_service
        reporter.service_done
      end
    end

    def run_service
      scope.each_testcase(service) do |test_case|
        @test_case = test_case
        reporter.before_test_case
        run_test_case
        reporter.test_case_done
      end
    end

    def run_test_case
      client.around(test_case) do
        reporter.before_each
        client.before(test_case)
        reporter.before_each_done

        reporter.before_instrument
        test_case.instrument(client)
        client.instrument(test_case)
        reporter.instrument_done

        reporter.before_invocation
        @response = client.call(test_case)
        @invocation = Tester::Invocation.new(test_case, @response, client)
        reporter.invocation_done

        reporter.before_assertions
        check_invocation
        reporter.assertions_done

        reporter.after_each
        client.after(test_case, @invocation)
        reporter.after_each_done
      end
    end

    def check_invocation
      @result = Result.from(self)
    end

    def after_all
      reporter.after_all
      config.listeners(:after_all).each do |l|
        l.call(config)
      end
      reporter.after_all_done
    end

  end # class Tester
end # module Webspicy
require_relative 'tester/reporter'
require_relative 'tester/client'
require_relative 'tester/invocation'
require_relative 'tester/result'
require_relative 'tester/failure'
require_relative 'tester/assertions'
require_relative 'tester/asserter'
require_relative 'tester/file_checker'
