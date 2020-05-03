module Webspicy
  class Tester

    def initialize(config)
      @config = Configuration.dress(config)
      @test_suite = load
    end
    attr_reader :config

    def call(err=$stderr, out=$stdout)
      $_rspec_core_load_started_at = nil
      options = RSpec::Core::ConfigurationOptions.new(config.rspec_options)
      conf = RSpec::Core::Configuration.new
      RSpec::Core::Runner.new(options, conf).run(err, out)
    end

  # protected

    def load
      tester = self
      RSpec.reset
      rspec_config!
      RSpec.describe "" do
        before(:all) do
          tester.config.listeners(:before_all).each do |l|
            l.call(tester.config)
          end
        end
        after(:all) do
          tester.config.listeners(:after_all).each do |l|
            l.call(tester.config)
          end
        end
        tester.config.each_scope do |scope|
          client = scope.get_client
          scope.each_resource do |resource|
            scope.each_service(resource) do |service|
              tester.rspec_service!(self, service, client, scope)
            end
          end
        end
      end
      self
    end

    def rspec_service!(on, service, client, scope)
      on.describe service do
        scope.each_testcase(service) do |test_case, counterexample|
          describe test_case do
            include_examples 'a successful test case invocation', client, test_case, counterexample
          end
        end
      end
    end

    def rspec_config!
      RSpec.shared_examples "a successful test case invocation" do |client, test_case, counterexample|

        around(:each) do |example|
          client.around(test_case) do
            client.before(test_case)
            test_case.instrument(client)
            client.instrument(test_case)
            @invocation = client.call(test_case)
            example.run
            client.after(test_case, @invocation)
            @invocation
          end
        end

        let(:invocation) do
          @invocation
        end

        it 'works' do
          raise "Test not ran" unless invocation.done?
          fails = [
            [:expected_status_unmet, true],
            [:expected_content_type_unmet, !test_case.is_expected_status?(204)],
            [:expected_headers_unmet, test_case.has_expected_headers?],
            [:expected_schema_unmet, !test_case.is_expected_status?(204)],
            [:assertions_unmet, test_case.has_assertions?],
            [:postconditions_unmet, test_case.service.has_postconditions? && !counterexample],
            [:expected_error_unmet, test_case.has_expected_error?]
          ].map do |(expectation,only_if)|
            next unless only_if
            begin
              invocation.send(expectation)
            rescue => ex
              ex.message
            end
          end
          fails = fails.compact
          raise "\n* " + fails.join("\n* ") + "\n" unless fails.empty?
        end
      end
    end

  end # class Tester
end # module Webspicy
