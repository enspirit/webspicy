require 'spec_helper'
module Webspicy
  module Support
    describe Hooks, "fire_around" do

      class Hooker
        include Hooks
        def initialize(config)
          @config = config
        end
        attr_reader :config
      end

      it 'work with no around at all' do
        config = Configuration.new

        seen = false
        block = ->(){ seen = true }

        Hooker.new(config).fire_around(1, 2, 3, &block)
        expect(seen).to be(true)
      end

      it 'work with one around' do
        config = Configuration.new

        seen = false
        seen_args = nil
        config.around_each do |*args, &bl|
          seen_args = args
          bl.call
        end

        block = ->(){ seen = true }
        Hooker.new(config).fire_around(1, 2, 3, &block)

        expect(seen_args).to eql([1, 2, 3])
        expect(seen).to be(true)
      end

      it 'works with two arounds' do
        config = Configuration.new

        seen = false

        seen_args = []
        config.around_each do |*args, &bl|
          seen_args << args
          bl.call
        end
        config.around_each do |*args, &bl|
          seen_args << args
          bl.call
        end

        block = ->(){ seen = true }
        Hooker.new(config).fire_around(1, 2, 3, &block)

        expect(seen_args.size).to eql(2)
        expect(seen_args.all?{|sa| sa == [1,2,3] }).to be(true)
        expect(seen).to be(true)
      end

    end
  end
end
