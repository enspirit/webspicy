require "spec_helper"
module Webspicy
  module Support
    describe DeepMerge, 'deep_dup' do
      it 'works on scalars' do
        expect(DeepMerge.deep_dup(12)).to eql(12)
      end

      it 'works on arrays' do
        xs = [1, 2, 3]
        expect(DeepMerge.deep_dup(xs)).to eql(xs)
        expect(DeepMerge.deep_dup(xs)).not_to be(xs)
      end

      it 'works on hashes' do
        xs = { foo: "bar" }
        expect(DeepMerge.deep_dup(xs)).to eql(xs)
        expect(DeepMerge.deep_dup(xs)).not_to be(xs)
      end

      it 'works recursively' do
        xs = { foo: { bar: [1, 2, 3] } }
        got = DeepMerge.deep_dup(xs)
        expect(got[:foo]).not_to be(xs[:foo])
        expect(got[:foo][:bar]).not_to be(xs[:foo][:bar])
      end
    end
    describe DeepMerge, 'deep_merge' do
      it 'works as expected' do
        h1 = { foo: { bar: "baz" }, times: [1, 2], only: { me: true } }
        h2 = { foo: { bor: "boz" }, times: [3, 4], not: { you: false } }
        expected = {
          foo: { bar: "baz", bor: "boz" },
          times: [1, 2, 3, 4],
          only: { me: true },
          not: { you: false }
        }
        got = DeepMerge.deep_merge(h1, h2)
        expect(got).to eql(expected)
        expect(got[:only]).not_to be(h1[:only])
        expect(got[:not]).not_to be(h2[:not])
      end
    end
  end
end
