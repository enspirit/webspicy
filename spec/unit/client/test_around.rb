require 'spec_helper'
module Webspicy
  describe Client, "around" do

    it 'work with no around at all' do
      config = Configuration.new

      seen = false
      block = ->(){ seen = true }

      scope = Scope.new(config)
      Client.new(scope).around(1, 2, 3, &block)
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

      scope = Scope.new(config)
      block = ->(){ seen = true }
      Client.new(scope).around(1, 2, 3, &block)

      expect(seen_args[0...-1]).to eql([1, 2, 3])
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

      scope = Scope.new(config)
      block = ->(){ seen = true }
      Client.new(scope).around(1, 2, 3, &block)

      expect(seen_args.size).to eql(2)
      expect(seen_args.all?{|sa| sa[0...-1] == [1,2,3] }).to be(true)
      expect(seen).to be(true)
    end

  end
end
