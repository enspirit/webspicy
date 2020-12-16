module Webspicy
  class Tester
    include Webspicy::Support::Colorize

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
      scope.each_testcase(service) do |test_case|
        str = "#{service} #{test_case}"
        str = colorize_highlight(str)
        on.describe(str) do
          include_examples 'a successful test case invocation', client, test_case
        end
      end
    end

    def rspec_config!
      RSpec.shared_examples "a successful test case invocation" do |client, test_case|

        around(:each) do |example|
          client.around(test_case) do
            client.before(test_case)
            test_case.instrument(client)
            client.instrument(test_case)
            @response = client.call(test_case)
            @invocation = Tester::Invocation.new(test_case, @response, client)
            example.run
            client.after(test_case, @invocation)
            @invocation
          end
        end

        let(:invocation) do
          @invocation
        end

        it "meets its specification" do
          raise "Test not ran" unless invocation.done?
          errors = invocation.errors
          raise "\n  (expected vs. got)\n\n* " + errors.join("\n* ") + "\n" unless errors.empty?
        end
      end
    end

  end # class Tester
end # module Webspicy
require_relative 'tester/invocation'
require_relative 'tester/assertions'
require_relative 'tester/asserter'
