require "spec_helper"
module Webspicy
  module Support
    describe StatusRange do

      it 'has a int information contract' do
        expect(StatusRange.int(100).range).to eql(100..100)
        expect(StatusRange.int(100).to_int).to eql(100)
      end

      it 'has a str information contract' do
        expect(StatusRange.str("3xx").range).to eql(300...400)
        expect(StatusRange.str("3xx").to_str).to eql("3xx")
      end

      it 'has a to_i that returns the first status of the range' do
        expect(StatusRange.int(300).to_i).to eql(300)
        expect(StatusRange.str("3xx").to_i).to eql(300)
      end

      it 'has a matching method' do
        expect(StatusRange.str("3xx") === 300).to eql(true)
        expect(StatusRange.str("3xx") === 302).to eql(true)
        expect(StatusRange.str("3xx") === 400).to eql(false)
      end

    end
  end
end
