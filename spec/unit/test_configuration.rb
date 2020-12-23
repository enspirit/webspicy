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

    describe '.dress' do

      it 'is idempotent' do
        c = Configuration.new
        expect(Configuration.dress(c)).to be(c)
      end

      it 'supports a config.rb file' do
        c = Configuration.dress(Path.dir/'configuration/config.rb')
        expect(c).to be_a(Configuration)
        expect(c.folder).to eq(Path.dir/'configuration')
        expect(c.preconditions.size).to eq(1)
      end

      it 'supports a folder having a config.rb file' do
        c = Configuration.dress(Path.dir/'configuration')
        expect(c).to be_a(Configuration)
        expect(c.folder).to eq(Path.dir/'configuration')
        expect(c.preconditions.size).to eq(1)
      end

      it 'supports an URL and returns a specific configuration instance' do
        c = Configuration.dress("http://google.com/")
        expect(c).to be_a(Configuration)
        expect(c.folder).to eq(Path.pwd)
        expect(c.each_scope.to_a.size).to eql(1)
        expect(c.each_scope.to_a.first.each_specification.to_a.size).to eql(1)
      end

      it 'supports a single .yml file and returns a specific configuration instance' do
        file = restful_folder/"formaldef/todo/get.yml"
        c = Configuration.dress(file)
        expect(c).to be_a(Configuration)
        expect(c.folder).to eq(restful_folder)
        expect(c.each_scope.to_a.size).to eql(1)
        expect(c.each_scope.to_a.first.each_specification.to_a.size).to eql(1)
      end

      it 'yields the block with the configuration, if given' do
        seen = nil
        Configuration.dress(Path.dir/'configuration'){|c|
          seen = c
        }
        expect(seen).to be_a(Configuration)
      end

      it 'raises if the folder has no config.rb file' do
        expect(->{
          Configuration.dress(Path.dir)
        }).to raise_error(/Missing config.rb file/)
      end

    end

    describe 'folder' do

      it 'returns the main folder without arg' do
        config = Configuration.new(Path.dir)
        expect(config.folder).to eql(Path.dir)
      end

      it 'creates a child when adding a folder' do
        Configuration.new(Path.dir) do |c|
          child = c.folder 'specification'
          expect(child).to be_a(Configuration)
          expect(child.folder).to eql(Path.dir/'specification')
        end
      end

      it 'yield the child to the block if any given' do
        Configuration.new(Path.dir) do |c|
          seen = nil
          c.folder 'specification' do |child|
            seen = child
          end
          expect(seen).to be_a(Configuration)
          expect(seen.folder).to eql(Path.dir/'specification')
        end
      end
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
        ENV.delete('ROBUST')
      end

      it 'ignores the environment is set explicitly' do
        ENV['ROBUST'] = 'yes'
        config = Configuration.new do |c|
          c.run_counterexamples = false
        end
        expect(config.run_counterexamples?).to eql(false)
        ENV.delete('ROBUST')
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
        expect(config.file_filter).to match("foo/bar/getTodo.yml")
        expect(config.file_filter).not_to match("foo/bar/getTodos.yml")
        ENV.delete('RESOURCE')
      end

      it 'allows expressing a no match' do
        ENV['RESOURCE'] = '!getTodo.yml'
        config = Configuration.new
        expect(config.file_filter).to be_a(Proc)
        expect(config.file_filter.call("foo/bar/getTodos.yml")).to eq(true)
        expect(config.file_filter.call("foo/bar/getTodo.yml")).to eq(false)
        ENV.delete('RESOURCE')
      end

      it 'ignores the environment if set explicitly' do
        ENV['RESOURCE'] = 'getTodo.yml'
        config = Configuration.new do |c|
          c.file_filter = nil
        end
        expect(config.file_filter).to be_nil
        ENV.delete('RESOURCE')
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
        ENV.delete('METHOD')
      end

      it 'ignores the environment is set explicitly' do
        ENV['METHOD'] = 'POST'
        config = Configuration.new do |c|
          c.service_filter = nil
        end
        expect(config.service_filter).to be_nil
        ENV.delete('METHOD')
      end
    end

    describe 'test_case_filter' do

      let(:tc){ OpenStruct.new(tags: ["foo", "bar"]) }

      subject {
        Configuration.new.test_case_filter
      }

      it 'is nil by default' do
        expect(subject).to be_nil
      end

      it 'allows setting a single tag' do
        ENV['TAG'] = 'foo'
        expect(subject).to be_a(Proc)
        expect(subject.call(tc)).to eql(true)
        ENV.delete('TAG')
      end

      it 'allows no matching a single tag' do
        ENV['TAG'] = 'baz'
        expect(subject).to be_a(Proc)
        expect(subject.call(tc)).to eql(false)
        ENV.delete('TAG')
      end

      it 'allows setting multiple tags' do
        ENV['TAG'] = 'foo,baz'
        expect(subject).to be_a(Proc)
        expect(subject.call(tc)).to eql(true)
        ENV.delete('TAG')
      end

      it 'allows no matching any of multiple tags' do
        ENV['TAG'] = 'foi,baz'
        expect(subject).to be_a(Proc)
        expect(subject.call(tc)).to eql(false)
        ENV.delete('TAG')
      end

      it 'allows setting a single negative tag' do
        ENV['TAG'] = '!foo'
        expect(subject).to be_a(Proc)
        expect(subject.call(tc)).to eql(false)
        ENV.delete('TAG')
      end

      it 'allows not matching a single negative tag' do
        ENV['TAG'] = '!baz'
        expect(subject).to be_a(Proc)
        expect(subject.call(tc)).to eql(true)
        ENV.delete('TAG')
      end

      it 'allows mixing positive & negative tags and have a match' do
        ENV['TAG'] = 'foo,!baz'
        expect(subject).to be_a(Proc)
        expect(subject.call(tc)).to eql(true)
        ENV.delete('TAG')
      end

      it 'allows mixing positive & negative tags and have no match' do
        ENV['TAG'] = 'foo,!bar'
        expect(subject).to be_a(Proc)
        expect(subject.call(tc)).to eql(false)
        ENV.delete('TAG')
      end

    end

    describe 'before/after/listeners' do

      let(:before_eacher) { ->(){} }
      let(:after_eacher) { ->(){} }
      let(:before_aller) { ->(){} }
      let(:after_aller) { ->(){} }
      let(:config) do
        Configuration.new(Path.dir/'specification') do |c|
          c.before_all(&before_aller)
          c.before_each(&before_eacher)
          c.after_each(&after_eacher)
          c.after_all(&after_aller)
        end
      end

      it 'correctly classifies and returns them on listeners' do
        expect(config.listeners(:before_each)).to eql([before_eacher])
        expect(config.listeners(:after_each)).to eql([after_eacher])
        expect(config.listeners(:before_all)).to eql([before_aller])
        expect(config.listeners(:after_all)).to eql([after_aller])
      end

    end

    describe 'dup' do

      let(:original) do
        Configuration.new(Path.dir/'specification') do |c|
          c.host = "http://127.0.0.1"
          c.folder 'service'
        end
      end

      it 'lets duplicate a configuration' do
        duped = original.dup do |d|
          d.host = "http://127.0.0.1:4567"
        end
        expect(duped.folder).to eql(Path.dir/'specification')
        expect(duped.host).to eql("http://127.0.0.1:4567")
        expect(original.host).to eql("http://127.0.0.1")
      end

      it 'duplicates the internal arrays to' do
        duped = original.dup do |d|
          d.rspec_options << "--hello"
          d.before_each do end
          d.after_each do end
          d.precondition Class.new
          d.postcondition Class.new
        end
        expect(duped.rspec_options.last).to eq("--hello")
        expect(original.rspec_options.last).not_to eq("--hello")
        expect(duped.preconditions.size).to eq(1)
        expect(duped.postconditions.size).to eq(1)

        expect(duped.listeners(:before_each).size).to eq(1)
        expect(original.listeners(:before_each).size).to eq(0)

        expect(original.preconditions.size).to eq(0)
        expect(original.postconditions.size).to eq(0)
      end

      it 'empties the children' do
        duped = original.dup
        expect(duped.children).to be_empty
      end
    end

  end
end
