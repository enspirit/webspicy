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
      RSpec.describe "Webspicy test suite" do
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
            client.after(test_case)
          end
        end

        let(:invocation) do
          @invocation
        end

        it 'meets its specification' do
          expect(invocation.done?).to eq(true)
          expect(invocation.expected_status_unmet).to(be_nil)
          expect(invocation.expected_content_type_unmet).to(be_nil)
          expect(invocation.expected_headers_unmet).to(be_nil) if test_case.has_expected_headers?
          expect(invocation.expected_schema_unmet).to(be_nil)
          expect(invocation.assertions_unmet).to(be_nil) if test_case.has_assertions?
          expect(invocation.postconditions_unmet).to(be_nil) if test_case.service.has_postconditions? and not(counterexample)
          expect(invocation.expected_error_unmet).to(be_nil) if test_case.has_expected_error?
        end
      end
    end

  end # class Tester
end # module Webspicy
