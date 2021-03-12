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

        it 'supports the block raising a Failure' do
          expect {
            sooner_or_later(max: 2){
              raise Tester::Failure
            }
          }.to raise_error(Tester::Failure)
        end

        it 'catches Failure occuring before successes' do
          seen = 0
          x = sooner_or_later(max: 2){
              seen += 1
            raise Tester::Failure if seen == 1
            12
          }
          expect(x).to eql(12)
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
