module Webspicy
  class Tester
    class RSpecTester
      include Webspicy::Support::RSpecRunnable

    protected

      def load_rspec_examples
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
            scope.each_specification do |specification|
              scope.each_service(specification) do |service|
                scope.each_testcase(service) do |test_case|
                  str = "#{service} #{test_case}"
                  str = Webspicy::Support::Colorize.colorize_highlight(str, tester.config)
                  describe(str) do

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
                      invocation.rspec_assert!(self)
                    end

                  end
                end
              end
            end
          end
        end
        self
      end

    end # class RSpecTester
  end # class Tester
end # module Webspicy
