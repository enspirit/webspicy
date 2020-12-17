require "spec_helper"
module Webspicy
  class Specification
    describe TestCase, "mutate" do

      it 'helps easily creating a new test by mutation' do
        tc = TestCase.new({
          :params => {
            "id" => 1
          }
        })
        tc2 = tc.mutate({
          :params => {
            "id" => 2
          }
        })
        expect(tc2).to be_a(TestCase)
        expect(tc.params["id"]).to eql(1)
        expect(tc2.params["id"]).to eql(2)
      end

    end
  end
end
