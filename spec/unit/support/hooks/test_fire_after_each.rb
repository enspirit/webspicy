require 'spec_helper'
module Webspicy
  module Support
    describe Hooks, "fire_after_each" do

      class Hooker
        include Hooks
        def initialize(config)
          @config = config
        end
        attr_reader :config
      end

      it 'work with no after_each at all' do
        config = Configuration.new
        Hooker.new(config).fire_after_each(1, 2, 3)
      end

      it 'work with one after_each' do
        config = Configuration.new

        seen_args = nil
        config.after_each do |*args|
          seen_args = args
        end

        Hooker.new(config).fire_after_each(1, 2, 3)

        expect(seen_args).to eql([1, 2, 3])
      end

      it 'works with two after_each' do
        config = Configuration.new

        seen = false

        seen_args = []
        config.after_each do |*args|
          seen_args << args
        end
        config.after_each do |*args|
          seen_args << args
        end

        Hooker.new(config).fire_after_each(1, 2, 3)

        expect(seen_args.size).to eql(2)
        expect(seen_args.all?{|sa| sa == [1,2,3] }).to be(true)
      end

    end
  end
end
