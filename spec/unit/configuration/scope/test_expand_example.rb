require 'spec_helper'
module Webspicy
  class Configuration
    describe Scope, "expand_example" do

      subject{ Scope.new({}).send(:expand_example, service, example) }

      context 'when the service has no default example' do
        let(:service) {
          Webspicy.service({
            method: "GET",
            description: "Test service",
            preconditions: "Foo",
            input_schema: "{ id: Integer }",
            output_schema: "{}",
            error_schema: "{}"
          })
        }

        let(:example) {
          Webspicy.test_case({
            description: "Hello world"
          })
        }

        it 'returns the example itself' do
          expect(subject).to be(example)
        end
      end

      context 'when the service has a default example' do
        let(:service) {
          Webspicy.service({
            method: "GET",
            description: "Test service",
            preconditions: "Foo",
            input_schema: "{ id: Integer }",
            output_schema: "{}",
            error_schema: "{}",
            default_example: {
              expected: { status: 200 }
            }
          })
        }

        let(:example) {
          Webspicy.test_case({
            description: "Hello world",
            expected: { content_type: "application/json" }
          })
        }

        it 'deep merges the default example and the example as expected' do
          expect(subject).to be_a(Specification::TestCase)
          expect(subject.description).to eql("Hello world")
          expect(subject.expected).to eql({
            status: Support::StatusRange.int(200),
            content_type: "application/json"
          })
        end
      end

    end
  end
end
