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

    describe 'file_filter' do

      it 'is nil by default' do
        config = Configuration.new
        expect(config.file_filter).to be_nil
      end

      it 'is implements backward compatibility with the RESOURCE env variable' do
        ENV['RESOURCE'] = 'getTodo.yml'
        config = Configuration.new
        expect(config.file_filter).to be_a(Regexp)
      end

      it 'ignores the environment is set explicitly' do
        ENV['RESOURCE'] = 'getTodo.yml'
        config = Configuration.new do |c|
          c.file_filter = nil
        end
        expect(config.file_filter).to be_nil
      end
    end

    describe 'service_filter' do

      it 'is nil by default' do
        config = Configuration.new
        expect(config.service_filter).to be_nil
      end

      it 'is implements backward compatibility with the RESOURCE env variable' do
        ENV['METHOD'] = 'GET'
        config = Configuration.new
        expect(config.service_filter).to be_a(Proc)
      end

      it 'ignores the environment is set explicitly' do
        ENV['METHOD'] = 'POST'
        config = Configuration.new do |c|
          c.service_filter = nil
        end
        expect(config.service_filter).to be_nil
      end
    end

    describe 'dup' do

      let(:original) do
        Configuration.new do |c|
          c.add_folder Path.dir/'resource'
          c.host = "http://127.0.0.1"
        end
      end

      it 'lets duplicate a configuration' do
        duped = original.dup do |d|
          d.host = "http://127.0.0.1:4567"
        end
        expect(duped.host).to eql("http://127.0.0.1:4567")
        expect(original.host).to eql("http://127.0.0.1")
      end

      it 'duplicates the internal arrays to' do
        duped = original.dup do |d|
          d.add_folder Path.dir/'scope'
          d.rspec_options << "--hello"
          d.before_each do end
        end
        expect(duped.folders.size).to eql(2)
        expect(original.folders.size).to eql(1)

        expect(duped.rspec_options.last).to eq("--hello")
        expect(original.rspec_options.last).not_to eq("--hello")

        expect(duped.before_listeners.size).to eq(1)
        expect(original.before_listeners.size).to eq(0)
      end
    end

  end
end
