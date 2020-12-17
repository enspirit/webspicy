require 'spec_helper'

module Webspicy
  class Specification
    module Precondition
      describe GlobalRequestHeaders do
        let(:gbr){
          GlobalRequestHeaders.new('Accept' => 'application/json')
        }

        describe "instrument" do
          it 'injects the headers' do
            tc = TestCase.new({})
            gbr.instrument(tc, nil)
            expect(tc.headers['Accept']).to eql("application/json")
          end

          it 'keeps original headers unchanged' do
            tc = TestCase.new({
              headers: {
                'Content-Type' => 'text/plain'
              }
            })
            gbr.instrument(tc, nil)
            expect(tc.headers['Content-Type']).to eql("text/plain")
            expect(tc.headers['Accept']).to eql("application/json")
          end

          it 'has low precedence' do
            tc = TestCase.new({
              headers: {
                'Accept' => 'text/plain'
              }
            })
            gbr.instrument(tc, nil)
            expect(tc.headers['Accept']).to eql("text/plain")
          end
        end
      end
    end
  end
end
