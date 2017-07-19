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

    describe 'run_counterexamples' do

      it 'is true by default' do
        config = Configuration.new
        expect(config.run_counterexamples?).to eql(true)
      end

      it 'implements backward compatibility with ROBUST env variable' do
        ENV['ROBUST'] = 'no'
        config = Configuration.new
        expect(config.run_counterexamples?).to eql(false)

        ENV['ROBUST'] = 'yes'
        config = Configuration.new
        expect(config.run_counterexamples?).to eql(true)
      end

      it 'ignores the environment is set explicitly' do
        ENV['ROBUST'] = 'yes'
        config = Configuration.new do |c|
          c.run_counterexamples = false
        end
        expect(config.run_counterexamples?).to eql(false)
      end
    end

  end
end
