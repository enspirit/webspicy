module Webspicy
  class Tester

    def initialize(config)
      @config = config
    end
    attr_reader :config

    def call
      Webspicy.with_scope_for(config) do |scope|
        client = scope.get_client
        scope.each_resource do |resource|
          scope.each_service(resource) do |service|
            RSpec.describe "#{service.method} `#{resource.url}`" do
              scope.each_example(service) do |test_case|
                describe test_case.description do

                  before(:all) do
                    client.before(test_case, service, resource)
                    @invocation ||= client.call(test_case, service, resource)
                  end

                  subject do
                    @invocation
                  end

                  it 'can be invoked successfuly' do
                    expect(subject.done?).to eq(true)
                  end

                  it 'meets the status and content type specification' do
                    expect(subject.expected_status_unmet).to(be_nil)
                    expect(subject.expected_content_type_unmet).to(be_nil)
                  end

                  it 'has the expected response headers' do
                    expect(subject.expected_headers_unmet).to(be_nil)
                  end if test_case.has_expected_headers?

                  it 'meets the output data schema' do
                    expect(subject.expected_schema_unmet).to(be_nil)
                  end

                  it 'meets all assertions' do
                    expect(subject.assertions_unmet).to(be_nil)
                  end if test_case.has_assertions?

                end
              end # service.examples

              scope.each_counterexamples(service) do |test_case|
                describe test_case.description do

                  before(:all) do
                    client.before(test_case, service, resource)
                    @invocation ||= client.call(test_case, service, resource)
                  end

                  subject do
                    @invocation
                  end

                  it 'can be invoked successfuly' do
                    expect(subject.done?).to eq(true)
                  end

                  it 'meets the status and content type specification' do
                    expect(subject.expected_status_unmet).to(be_nil)
                    expect(subject.expected_content_type_unmet).to(be_nil)
                  end

                  it 'has the expected response headers' do
                    expect(subject.expected_headers_unmet).to(be_nil)
                  end if test_case.has_expected_headers?

                  it 'meets the output data schema' do
                    expect(subject.expected_schema_unmet).to(be_nil)
                  end

                  it 'meets all assertions' do
                    expect(subject.assertions_unmet).to(be_nil)
                  end if test_case.has_assertions?

                  it 'has expected error' do
                    expect(subject.expected_error_unmet).to(be_nil)
                  end if test_case.has_expected_error?

                end
              end
            end
          end
        end
        RSpec::Core::Runner.run config.rspec_options
      end
    end

  end # class Tester
end # module Webspicy
