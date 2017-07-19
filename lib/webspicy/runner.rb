module Webspicy
  class Runner

    def initialize(config)
      @config = config
    end
    attr_reader :config

    def run
      Webspicy.with_scope_for(config) do |scope|
        scope.each_resource do |resource|
          scope.each_service(resource) do |service|
            RSpec.describe "#{service.method} `#{resource.url}`" do
              scope.each_example(service) do |test_case|
                describe test_case.description do

                  before(:all) do
                    @api = Webspicy::RestClient.new(scope)
                    @invocation = service.invoke_on(@api, resource, test_case, scope)
                  end

                  let(:invocation) {
                    @invocation
                  }

                  it 'can be invoked successfully' do
                    expect(invocation.done?).to eq(true)
                    expect(invocation.expected_status_unmet).to(be_nil) if invocation.done?
                    expect(invocation.expected_content_type_unmet).to(be_nil) if invocation.done?
                    expect(invocation.expected_headers_unmet).to(be_nil) if invocation.done?
                    expect(invocation.expected_schema_unmet).to(be_nil) if invocation.done?
                    expect(invocation.assertions_unmet).to(be_nil) if invocation.done?
                  end

                end
              end # service.examples

              scope.each_counterexamples(service) do |test_case|
                describe test_case.description do

                  before(:all) do
                    @api = Webspicy::RestClient.new(scope)
                    @invocation = service.invoke_on(@api, resource, test_case, scope)
                  end

                  let(:invocation) {
                    @invocation
                  }

                  it 'can be invoked successfully' do
                    expect(invocation.done?).to eq(true)
                    expect(invocation.expected_status_unmet).to(be_nil) if invocation.done?
                    expect(invocation.expected_headers_unmet).to(be_nil) if invocation.done?
                    expect(invocation.expected_schema_unmet).to(be_nil) if invocation.done?
                    expect(invocation.assertions_unmet).to(be_nil) if invocation.done?
                    expect(invocation.expected_error_unmet).to(be_nil) if invocation.done?
                  end

                end
              end
            end
          end
        end
        RSpec::Core::Runner.run []
      end
    end

  end
end
