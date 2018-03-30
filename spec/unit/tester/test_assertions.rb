require 'spec_helper'

module Webspicy
  class Tester
    describe Assertions do
      include Assertions

      public :extract_path

      it 'has an extract_path helper' do
        target = { foo: "Hello", bar: { foo: "Hello" }, baz: [{ foo: "world" }] }
        expect(extract_path(target)).to be(target)
        expect(extract_path(target, nil)).to be(target)
        expect(extract_path(target, '')).to be(target)
        expect(extract_path(target, 'foo')).to eql("Hello")
        expect(extract_path(target, 'bar/foo')).to eql("Hello")
        expect(extract_path(target, 'baz/0')).to eql({ foo: "world" })
        expect(extract_path(target, 'baz/0/foo')).to eql("world")
      end

      it 'has an includes() assertion' do
        expect(includes [], 1).to be(false)
        expect(includes [5, 1], 1).to be(true)
      end

      it 'has an notIcludes() assertion' do
        expect(notIncludes [], 1).to be(true)
        expect(notIncludes [5, 1], 1).to be(false)
      end

      it 'has an exists() assertion' do
        expect(exists nil).to be(false)
        expect(exists []).to be(true)
        expect(exists [1]).to be(true)
        expect(exists({ foo: [] }, 'foo')).to be(true)
        expect(exists({ foo: {} }, 'foo')).to be(true)
        expect(exists({ foo: {} }, 'foo/bar')).to be(false)
      end

      it 'has an notExists() assertion' do
        expect(notExists nil).to be(true)
        expect(notExists []).to be(false)
        expect(notExists [1]).to be(false)
        expect(notExists({ foo: [] }, 'foo')).to be(false)
        expect(notExists({ foo: {} }, 'foo')).to be(false)
        expect(notExists({ foo: {} }, 'foo/bar')).to be(true)
      end

      it 'has an empty() assertion' do
        expect(empty []).to be(true)
        expect(empty [1]).to be(false)
        expect(empty({ foo: [] }, 'foo')).to be(true)
        expect(empty({ foo: [1] }, 'foo')).to be(false)
      end

      it 'has a notEmpty() assertion' do
        expect(notEmpty []).to be(false)
        expect(notEmpty [1]).to be(true)
        expect(notEmpty({ foo: [] }, 'foo')).to be(false)
        expect(notEmpty({ foo: [1] }, 'foo')).to be(true)
      end

      it 'has an size() assertion' do
        expect(size [], 0).to be(true)
        expect(size [], 1).to be(false)
        expect(size [12], 1).to be(true)
        expect(size({ foo: [] }, 'foo', 0)).to be(true)
        expect(size({ foo: [] }, 'foo', 1)).to be(false)
        expect(size({ foo: ['bar'] }, 'foo', 1)).to be(true)
      end

      it 'has an idIn assertion' do
        expect(idIn [{id: 1}, {id: 2}], [1, 2]).to be(true)
        expect(idIn [{id: 1}, {id: 2}], [2, 1]).to be(true)
        expect(idIn [{id: 1}, {id: 2}], [1, 3]).to be(false)
        expect(idIn [{id: 1}, {id: 2}], [1]).to be(false)
        expect(idIn({ foo: [{id: 1}, {id: 2}] }, 'foo', [1, 2])).to be(true)

        expect(idIn({id: 1}, [1])).to be(true)
        expect(idIn({id: 1}, [2])).to be(false)
      end

      it 'has an idNotIn assertion' do
        expect(idNotIn [{id: 1}, {id: 2}], [3]).to be(true)
        expect(idNotIn [{id: 1}, {id: 2}], [3, 4]).to be(true)
        expect(idNotIn [{id: 1}, {id: 2}], [1]).to be(false)
        expect(idNotIn({ foo: [{id: 1}, {id: 2}] }, 'foo', [1])).to be(false)
        expect(idNotIn({ foo: [{id: 1}, {id: 2}] }, 'foo', [3])).to be(true)

        expect(idNotIn({id: 1}, [3])).to be(true)
        expect(idNotIn({id: 1}, [1])).to be(false)
      end

      it 'has an idFD assertion' do
        target = { foo: [
          { id: 1, bar: "bar" },
          { id: 2, bar: "baz" }
        ] }
        expect(idFD(target, 'foo', 1, bar: "bar")).to be(true)
        expect(idFD(target, 'foo', 1, bar: "baz")).to be(false)
        expect(idFD(target, 'foo', 1, baz: "boz")).to be(false)

        target = { foo: { id: 1, bar: "bar" } }
        expect(idFD(target, 'foo', 1, bar: "bar")).to be(true)
        expect(idFD(target, 'foo', 1, bar: "baz")).to be(false)
        expect(idFD(target, 'foo', 1, baz: "boz")).to be(false)
      end

      it 'has an pathFD assertion' do
        target = { foo: { bar: "baz"} }
        expect(pathFD(target, 'foo', bar: "baz")).to be(true)
        expect(pathFD(target, 'foo', bar: "boz")).to be(false)
        expect(pathFD(target, 'foo', boz: "biz")).to be(false)
      end

      it 'has a match assertion' do
        target = "hello world"
        expect(match(target, '', /world/)).to be(true)
        expect(match(target, '', /foobar/)).to be(false)
      end

      it 'has a notMatch assertion' do
        target = "hello world"
        expect(notMatch(target, '', /world/)).to be(false)
        expect(notMatch(target, '', /foobar/)).to be(true)
      end

    end
  end # class Tester
end # module Webspicy
