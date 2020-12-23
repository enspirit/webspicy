require 'spec_helper'
module Webspicy
  module Support
    describe Hooks, "fire_instrument" do

      class Hooker
        include Hooks
        def initialize(config)
          @config = config
        end
        attr_reader :config
      end

      it 'work with no instrument at all' do
        config = Configuration.new
        Hooker.new(config).fire_instrument(1, 2, 3)
      end

      it 'work with one instrument' do
        config = Configuration.new

        seen_args = nil
        config.instrument do |*args|
          seen_args = args
        end

        Hooker.new(config).fire_instrument(1, 2, 3)

        expect(seen_args).to eql([1, 2, 3])
      end

      it 'works with two instrument' do
        config = Configuration.new

        seen = false

        seen_args = []
        config.instrument do |*args|
          seen_args << args
        end
        config.instrument do |*args|
          seen_args << args
        end

        Hooker.new(config).fire_instrument(1, 2, 3)

        expect(seen_args.size).to eql(2)
        expect(seen_args.all?{|sa| sa == [1,2,3] }).to be(true)
      end

    end
  end
end
