require 'spec_helper'

module Webspicy
  module SpecTests
    class Queue
      include Webspicy::Support::World::Item

    end
  end
end

module Webspicy
  module Support
    describe World do

      let(:config){
        Configuration.new(restful_folder)
      }

      subject do
        World.new Path.dir/"fixtures", config
      end

      it 'supports single objects' do
        expect(subject.single.name).to eql("single")
        expect(subject.single.version.minor).to eql("0")
        expect(subject.single.hobbies[0].name).to eql("programming")
      end

      it 'supports yaml too' do
        expect(subject.yaml.name).to eql("YAML")
      end

      it 'supports arrays' do
        expect(subject.array[0].name).to eql("foo")
        expect(subject.array[1].name).to eql("bar")
      end

      it 'allows setting new attributes on itself' do
        subject.foo = "bar"
        expect(subject.foo).to eql("bar")
      end

      it 'allows setting new attributes on existing objects' do
        subject.single.foo = "bar"
        expect(subject.single.foo).to eql("bar")
      end

      it 'supports ruby files and evaluates them' do
        q = subject.queue
        expect(q).to be_a(Webspicy::SpecTests::Queue)
        expect(q.config).to be(config)
      end
    end
  end
end
