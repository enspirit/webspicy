require "spec_helper"
module Webspicy
  class Specification
    describe Condition do
      describe "sooner_or_later" do
        include Condition

        it 'works when the block returns anything non falsy' do
          x = sooner_or_later(max: 1){ 12 }
          expect(x).to eql(12)
        end

        it 'returns nil otherwise' do
          x = sooner_or_later(max: 1){ nil }
          expect(x).to eql(nil)
        end

        it 'can raise for us' do
          expect{
            sooner_or_later(max: 1, raise: true){ nil }
          }.to raise_error(TimeoutError)
        end
      end
    end
  end
end
