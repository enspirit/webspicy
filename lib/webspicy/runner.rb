module Webspicy
  class Runner

    def initialize(config)
      @config = config
    end
    attr_reader :config

    def run
      Webspicy.with_scope_for(config) do |scope|
        client = scope.get_client
        scope.each_resource do |resource|
          scope.each_service(resource) do |service|
            RSpec.describe "#{service.method} `#{resource.url}`" do
              scope.each_example(service) do |test_case|
                describe test_case.description do

                  subject {
                    client.call(test_case, service, resource)
                  }

                  it 'meets its specification' do
                    expect(subject.done?).to eq(true)
                    expect(subject.expected_status_unmet).to(be_nil) if subject.done?
                    expect(subject.expected_content_type_unmet).to(be_nil) if subject.done?
                    expect(subject.expected_headers_unmet).to(be_nil) if subject.done?
                    expect(subject.expected_schema_unmet).to(be_nil) if subject.done?
                    expect(subject.assertions_unmet).to(be_nil) if subject.done?
                  end

                end
              end # service.examples

              scope.each_counterexamples(service) do |test_case|
                describe test_case.description do

                  subject {
                    client.call(test_case, service, resource)
                  }

                  it 'meets its specification' do
                    expect(subject.done?).to eq(true)
                    expect(subject.expected_status_unmet).to(be_nil) if subject.done?
                    expect(subject.expected_headers_unmet).to(be_nil) if subject.done?
                    expect(subject.expected_schema_unmet).to(be_nil) if subject.done?
                    expect(subject.assertions_unmet).to(be_nil) if subject.done?
                    expect(subject.expected_error_unmet).to(be_nil) if subject.done?
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
