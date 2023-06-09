require 'spec_helper'

module Webspicy
  class Tester
    describe Assertions do

      class A
        include Assertions

        public :extract_path
      end

      let(:a) do
        A.new
      end

      it 'has an extract_path helper' do
        target = { foo: "Hello", bar: { foo: "Hello" }, baz: [{ foo: "world" }] }
        expect(a.extract_path(target)).to be(target)
        expect(a.extract_path(target, nil)).to be(target)
        expect(a.extract_path(target, '')).to be(target)
        expect(a.extract_path(target, 'foo')).to eql("Hello")
        expect(a.extract_path(target, 'bar/foo')).to eql("Hello")
        expect(a.extract_path(target, 'baz/0')).to eql({ foo: "world" })
        expect(a.extract_path(target, 'baz/0/foo')).to eql("world")
      end

      it 'has an includes() assertion' do
        expect(a.includes [], 1).to be(false)
        expect(a.includes [5, 1], 1).to be(true)
      end

      it 'has a notIncludes() assertion' do
        expect(a.notIncludes [], 1).to be(true)
        expect(a.notIncludes [5, 1], 1).to be(false)
      end

      it 'has an exists() assertion' do
        expect(a.exists nil).to be(false)
        expect(a.exists []).to be(true)
        expect(a.exists [1]).to be(true)
        expect(a.exists({ foo: [] }, 'foo')).to be(true)
        expect(a.exists({ foo: {} }, 'foo')).to be(true)
        expect(a.exists({ foo: {} }, 'foo/bar')).to be(false)
      end

      it 'has a notExists() assertion' do
        expect(a.notExists nil).to be(true)
        expect(a.notExists []).to be(false)
        expect(a.notExists [1]).to be(false)
        expect(a.notExists({ foo: [] }, 'foo')).to be(false)
        expect(a.notExists({ foo: {} }, 'foo')).to be(false)
        expect(a.notExists({ foo: {} }, 'foo/bar')).to be(true)
      end

      it 'has an empty() assertion' do
        expect(a.empty []).to be(true)
        expect(a.empty [1]).to be(false)
        expect(a.empty({ foo: [] }, 'foo')).to be(true)
        expect(a.empty({ foo: [1] }, 'foo')).to be(false)
      end

      it 'has a notEmpty() assertion' do
        expect(a.notEmpty []).to be(false)
        expect(a.notEmpty [1]).to be(true)
        expect(a.notEmpty({ foo: [] }, 'foo')).to be(false)
        expect(a.notEmpty({ foo: [1] }, 'foo')).to be(true)
      end

      it 'has a size() assertion' do
        expect(a.size [], 0).to be(true)
        expect(a.size [], 1).to be(false)
        expect(a.size [12], 1).to be(true)
        expect(a.size({ foo: [] }, 'foo', 0)).to be(true)
        expect(a.size({ foo: [] }, 'foo', 1)).to be(false)
        expect(a.size({ foo: ['bar'] }, 'foo', 1)).to be(true)
      end

      it 'has an idIn assertion' do
        expect(a.idIn [{id: 1}, {id: 2}], [1, 2]).to be(true)
        expect(a.idIn [{id: 1}, {id: 2}], [2, 1]).to be(true)
        expect(a.idIn [{id: 1}, {id: 2}], [1, 3]).to be(false)
        expect(a.idIn [{id: 1}, {id: 2}], [1]).to be(false)
        expect(a.idIn({ foo: [{id: 1}, {id: 2}] }, 'foo', [1, 2])).to be(true)

        expect(a.idIn({id: 1}, [1])).to be(true)
        expect(a.idIn({id: 1}, [2])).to be(false)
      end

      it 'has an idNotIn assertion' do
        expect(a.idNotIn [{id: 1}, {id: 2}], [3]).to be(true)
        expect(a.idNotIn [{id: 1}, {id: 2}], [3, 4]).to be(true)
        expect(a.idNotIn [{id: 1}, {id: 2}], [1]).to be(false)
        expect(a.idNotIn({ foo: [{id: 1}, {id: 2}] }, 'foo', [1])).to be(false)
        expect(a.idNotIn({ foo: [{id: 1}, {id: 2}] }, 'foo', [3])).to be(true)

        expect(a.idNotIn({id: 1}, [3])).to be(true)
        expect(a.idNotIn({id: 1}, [1])).to be(false)
      end

      it 'has an idFD assertion' do
        target = { foo: [
          { id: 1, bar: "bar" },
          { id: 2, bar: "baz" }
        ] }
        element = a.element_with_id(target, 'foo', 1)
        expect(a.idFD(element, bar: "bar")).to be(true)
        expect(a.idFD(element, bar: "baz")).to be(false)
        expect(a.idFD(element, baz: "boz")).to be(false)

        target = { foo: { id: 1, bar: "bar" } }
        element = a.element_with_id(target, 'foo', 1)
        expect(a.idFD(element, bar: "bar")).to be(true)
        expect(a.idFD(element, bar: "baz")).to be(false)
        expect(a.idFD(element, baz: "boz")).to be(false)
      end

      it 'has a pathFD assertion' do
        target = { foo: { bar: "baz"} }
        expect(a.pathFD(target, 'foo', bar: "baz")).to be(true)
        expect(a.pathFD(target, 'foo', bar: "boz")).to be(false)
        expect(a.pathFD(target, 'foo', boz: "biz")).to be(false)
      end

      it 'has a match assertion' do
        target = "hello world"
        expect(a.match(target, '', /world/)).to be(true)
        expect(a.match(target, '', /foobar/)).to be(false)
      end

      it 'has a notMatch assertion' do
        target = "hello world"
        expect(a.notMatch(target, '', /world/)).to be(false)
        expect(a.notMatch(target, '', /foobar/)).to be(true)
      end

    end
  end # class Tester
end # module Webspicy
