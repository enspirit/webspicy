require 'spec_helper'
module Webspicy
  describe Configuration do

    it 'yields itself at construction' do
      seen = nil
      Configuration.new do |c|
        seen = c
      end
      expect(seen).to be_a(Configuration)
    end

  end
end
