require 'spec_helper'

module Webspicy
  class Specification
    module Pre
      describe GlobalRequestHeaders do
        let(:gbr){
          GlobalRequestHeaders.new('Accept' => 'application/json')
        }

        def instrument(tc)
          t = OpenStruct.new(test_case: tc)
          gbr.bind(t).instrument
        end

        describe "instrument" do
          it 'injects the headers' do
            tc = TestCase.new({})
            instrument(tc)
            expect(tc.headers['Accept']).to eql("application/json")
          end

          it 'keeps original headers unchanged' do
            tc = TestCase.new({
              headers: {
                'Content-Type' => 'text/plain'
              }
            })
            instrument(tc)
            expect(tc.headers['Content-Type']).to eql("text/plain")
            expect(tc.headers['Accept']).to eql("application/json")
          end

          it 'has low precedence' do
            tc = TestCase.new({
              headers: {
                'Accept' => 'text/plain'
              }
            })
            instrument(tc)
            expect(tc.headers['Accept']).to eql("text/plain")
          end
        end
      end
    end
  end
end
