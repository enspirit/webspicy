module Webspicy
  class Tester

    def initialize(config)
      @config = Configuration.dress(config)
    end
    attr_reader :config

    def call
      rspec_config!
      tester = self
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
      RSpec::Core::Runner.run config.rspec_options
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
      return if @rspec_config
      RSpec.shared_examples "a successful test case invocation" do |client, test_case, counterexample|

        before(:all) do
          @invocation ||= begin
            client.before(test_case)
            test_case.instrument(client)
            client.call(test_case)
          end
        end

        after(:all) do
          client.after(test_case)
        end

        let(:invocation) do
          @invocation
        end

        it 'meets the HTTP specification' do
          expect(invocation.done?).to eq(true)
          expect(invocation.expected_status_unmet).to(be_nil)
          expect(invocation.expected_content_type_unmet).to(be_nil)
          expect(invocation.expected_headers_unmet).to(be_nil) if test_case.has_expected_headers?
          expect(invocation.expected_schema_unmet).to(be_nil)
        end

        it 'meets all specific assertions' do
          expect(invocation.assertions_unmet).to(be_nil)
        end if test_case.has_assertions?

        it 'meets declarative postconditions' do
          expect(invocation.postconditions_unmet).to(be_nil)
        end if test_case.service.has_postconditions? and not(counterexample)

        it 'meets the specific error messages, if any (backward compatibility)' do
          expect(@invocation.expected_error_unmet).to(be_nil)
        end if test_case.has_expected_error?
      end
      @rspec_config = true
    end

  end # class Tester
end # module Webspicy
