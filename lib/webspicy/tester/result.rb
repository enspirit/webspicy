module Webspicy
  class Tester
    class Result
      extend Forwardable

      def initialize(tester)
        @tester = tester
        @invocation = tester.invocation
        @assertions = []
        @failures = []
        @errors = []
        check!
      end
      attr_reader :tester, :invocation
      attr_reader :assertions, :failures, :errors

      def_delegators :@tester, *[
        :reporter
      ]

      def_delegators :@invocation, *[
        :config,
        :scope,
        :client,
        :specification,
        :service,
        :test_case
      ]

      def self.from(tester)
        new(tester)
      end

      def success?
        failures.empty? && errors.empty?
      end

      def failure?
        errors.empty? && !failures.empty?
      end

      def error?
        !errors.empty?
      end

      def assertions_count
        assertions.size
      end

      def failures_count
        failures.size
      end

      def errors_count
        errors.size
      end

    private

      def check!
        check_response!
        check_output! if success? && test_case.example?
        check_error! if success? && test_case.counterexample?
        check_assertions! if success?
        check_postconditions! if success? && test_case.example?
        check_errconditions! if success? && test_case.counterexample?
      end

    private

      def check_response!
        check_one! Result::ResponseStatusMet
        if ect = test_case.expected_content_type
          check_one! Result::ResponseHeaderMet.new(self, "Content-Type", ect)
        end
        test_case.expected_headers.each_pair do |k,v|
          check_one! Result::ResponseHeaderMet.new(self, k, v)
        end
      end

      def check_output!
        check_one! Result::OutputSchemaMet
      end

      def check_error!
        check_one! Result::ErrorSchemaMet
      end

      def check_assertions!
        test_case.assert.each do |a|
          check_one! Result::AssertMet.new(self, a)
        end
      end

      def check_postconditions!
        service.postconditions.each do |c|
          check_one! Result::PostconditionMet.new(self, c)
        end
      end

      def check_errconditions!
        service.errconditions.each do |c|
          check_one! Result::ErrconditionMet.new(self, c)
        end
      end

      def check_one!(check)
        if check.is_a?(Class)
          check_one!(check.new(self))
        else
          return unless check.must?
          begin
            check.call
            reporter.check_success(check)
          rescue *PASSTHROUGH_EXCEPTIONS
            raise
          rescue Failure => e
            self.failures << [check, e]
            reporter.check_failure(check, e)
          rescue Exception => e
            self.errors << [check, e]
            reporter.check_error(check, e)
          ensure
            self.assertions << check
          end
        end
      end

    end # class Result
  end # class Tester
end # module Webspicy
require_relative "result/check"
require_relative "result/response_status_met"
require_relative "result/response_header_met"
require_relative "result/output_schema_met"
require_relative "result/error_schema_met"
require_relative "result/assert_met"
require_relative "result/postcondition_met"
require_relative "result/errcondition_met"
