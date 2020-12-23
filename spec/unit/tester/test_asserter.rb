require 'spec_helper'

module Webspicy
  class Tester
    describe Asserter do
      describe '#includes' do
        it 'returns nil when the value is found in an array' do
          expect(Asserter.new([:a, 'foo', 99]).includes('', 'foo'))
            .to eq nil
        end

        it 'returns nil when the assertion is identical to a non-array' do
          expect(Asserter.new({ foo: Time.at(0) }).includes('', { foo: Time.at(0) }))
            .to eq nil
        end

        it 'raises an exception with a descriptive message when the assertion is false' do
          expect { Asserter.new([:a, 'foo', 99]).includes('', 42) }
            .to raise_exception Failure,
                                'Expected ["a","foo",99] to include 42'

        end
      end

      describe '#notIncludes' do
        it 'returns nil when the value is not found in an array' do
          expect(Asserter.new([:a, 'foo', 99]).notIncludes('', 'boom'))
            .to eq nil
        end

        it 'returns nil when the assertion and target are not identical' do
          expect(Asserter.new({ foo: Time.at(0) }).notIncludes('', 'LOL'))
            .to eq nil
        end

        it 'raises an exception with a descriptive message when the assertion is false' do
          expect { Asserter.new([:a, 'foo', 99]).notIncludes('', 'foo') }
            .to raise_exception Failure,
                                'Expected ["a","foo",99] not to include foo'
        end
      end

      describe '#empty' do
        it 'returns nil when the target is empty' do
          expect(Asserter.new([]).empty).to eq nil
          expect(Asserter.new({}).empty).to eq nil
        end

        it 'raises an exception with a descriptive message when the assertion is false' do
          expect { Asserter.new(['foo']).empty }
            .to raise_exception Failure,
                                'Expected ["foo"] to be empty'
        end
      end

      describe '#notEmpty' do
        it 'returns nil when the target is not empty' do
          expect(Asserter.new(['foo']).notEmpty).to eq nil
          expect(Asserter.new({ foo: 'bar' }).notEmpty).to eq nil
        end

        it 'raises an exception with a descriptive message when the assertion is false' do
          expect { Asserter.new([]).notEmpty }
            .to raise_exception Failure,
                                'Expected [] to be non empty'
          expect { Asserter.new({}).notEmpty }
            .to raise_exception Failure,
                                'Expected {} to be non empty'
        end
      end

      describe '#size' do
        let(:target) { [1, 2, 3, 4] }
        let(:asserter) { Asserter.new(target) }

        it 'returns nil when the assertion is true for a plain array' do
          expect(asserter.size('', 4)).to eq nil
        end

        it 'raises an exception with a descriptive message when the assertion is false' do
          expect { asserter.size('', 3) }
            .to raise_exception Failure, 'Expected [1,2,3,4] to have a size of 3, actual size is: 4'
        end

        context 'with a string' do
          let(:target) { 'FooBaz' }

          it 'returns nil when the assertion is true' do
            expect(asserter.size('', 6)).to eq nil
          end
        end

        context 'with an array at a nested path' do
          let(:target) { { foo: [1, 2, { bar: [10, 11, 12] }, 4] } }

          it 'returns nil when the assertion is true' do
            expect(asserter.size('foo/2/bar', 3)).to eq nil
          end

          it 'raises an exception with a descriptive message when the assertion is false' do
            expect { asserter.size('foo/2/bar', 99) }
              .to raise_exception Failure,
                                  'Expected [10,11,12] to have a size of 99, actual size is: 3'
          end

          it 'raises an InvalidArgError when the path is invalid' do
            expect { asserter.size('foo/28/bar', 99) }
              .to raise_exception Webspicy::Tester::Assertions::InvalidArgError,
                                  'Expecting instance responding to size'
          end
        end
      end

      describe '#idIn' do
        it 'returns nil when the specified ids match exactly' do
          expect(Asserter.new([{ id: 1 }, { id: 2 }]).idIn('', 1, 2)).to eq nil
          expect(Asserter.new({ id: 123 }).idIn('', 123)).to eq nil

          os = OpenStruct.new(id: 'foo')
          expect(Asserter.new(os).idIn('', 'foo')).to eq nil
        end

        it 'raises an exception with a descriptive message when the assertion is false' do
          expect { Asserter.new([{ id: 1}, { id: 2}]).idIn('', 123, 125) }
            .to raise_exception Failure,
                                'Expected [{"id":1},{"id":2}] to have ids 123,125'
          expect { Asserter.new([{ id: 1}, { id: 2}]).idIn('', 1, 2, 3) }
            .to raise_exception Failure,
                                'Expected [{"id":1},{"id":2}] to have ids 1,2,3'
          expect { Asserter.new([{ id: 1}, { id: 2}]).idIn('', 1) }
            .to raise_exception Failure,
                                'Expected [{"id":1},{"id":2}] to have ids 1'
        end
      end

      describe '#idNotIn' do
        it 'returns nil when the specified ids do not match exactly' do
          expect(Asserter.new([{ id: 1 }, { id: 2 }]).idNotIn('', 123, 125)).to eq nil
          expect(Asserter.new({ id: 123 }).idNotIn('', 1, 2, 3)).to eq nil
          expect(Asserter.new({ id: 123 }).idNotIn('', 1)).to eq nil
        end

        it 'raises an exception with a descriptive message when the assertion is false' do
          expect { Asserter.new([{ id: 1}, { id: 2}]).idNotIn('', 1, 2) }
            .to raise_exception Failure,
                                'Expected [{"id":1},{"id":2}] to not have ids 1,2'
          expect { Asserter.new({ id: 1}).idNotIn('', 1) }
            .to raise_exception Failure,
                                'Expected {"id":1} to not have ids 1'

          os = OpenStruct.new(id: 'foo')
          expect { Asserter.new(os).idNotIn('', 'foo') }
            .to raise_exception Failure,
                                'Expected "#<OpenStruct id=\"foo\">"... to not have ids foo'
        end
      end
    end

    describe '#idFD' do
      let(:target) do
        [
          { id: 1, a: 'a1', b: 'b1' },
          { id: 2, a: 'a2', b: 'b2' }
        ]
      end

      it 'returns nil when the element with specified id matches the expected keys-value pairs' do
        expect(Asserter.new(target).idFD('', 2, { b: 'b2' })).to eq nil
        expect(Asserter.new(target).idFD('', 2, { a: 'a2', b: 'b2' })).to eq nil
      end

      it 'raises an exception when the assertion is false' do
        expect { Asserter.new(target).idFD('', 2, { c: 'c2' }) }
          .to raise_exception Failure,
                              'Expected [{"id":1,"a":"a1","b":"b1"... ' \
                              'to contain the key(s) and value(s) {:c=>"c2"}'
        expect { Asserter.new(target).idFD('', 2, { b: 'b1' }) }
          .to raise_exception Failure,
                              'Expected [{"id":1,"a":"a1","b":"b1"... ' \
                              'to contain the key(s) and value(s) {:b=>"b1"}'
      end

      it 'raises an exception with a descriptive message when no element with the specified id is present in target' do
        expect { Asserter.new(target).idFD('', 3, { a: 'a3' }) }
          .to raise_exception Failure,
                              'Expected an element with id 3 to contain ' \
                              'the key(s) and value(s) {:a=>"a3"}, '\
                              'but there is no element with that id'
      end
    end

    describe '#pathFD' do
      let(:target) do
        [
          { a: 'a1', b: 'b1' },
          { a: 'a2', b: 'b2' }
        ]
      end

      it 'returns nil when the target matches the expected keys-value pairs' do
        expect(Asserter.new(target).pathFD('0', { b: 'b1' })).to eq nil
        expect(Asserter.new(target).pathFD('0', { a: 'a1', b: 'b1' })).to eq nil
        expect(Asserter.new(target).pathFD('1', { b: 'b2' })).to eq nil
        expect(Asserter.new(target).pathFD('1', { a: 'a2', b: 'b2' })).to eq nil
      end

      it 'raises an exception when the assertion is false' do
        expect { Asserter.new(target).pathFD('0', { c: 'c2' }) }
          .to raise_exception Failure,
                              'Expected {"a":"a1","b":"b1"} ' \
                              'to contain the key(s) and value(s) {:c=>"c2"}'
        expect { Asserter.new(target).pathFD('0', { b: 'b2' }) }
          .to raise_exception Failure,
                              'Expected {"a":"a1","b":"b1"} ' \
                              'to contain the key(s) and value(s) {:b=>"b2"}'
      end
    end

    describe '#match' do
      it 'returns nil when the target matches the specified regexp' do
        expect(Asserter.new('Empathise').match('', /path/)).to eq nil
        expect(Asserter.new('Empathise').match('', /.mp/)).to eq nil
      end

      it 'raises an exception when the assertion is false' do
        expect { Asserter.new('Empathise').match('', /ize/) }
          .to raise_exception Failure,
                              'Expected "Empathise" to match /ize/'
      end
    end

    describe '#notMatch' do
      it 'returns nil when the target does not matche the specified regexp' do
        expect(Asserter.new('Empathise').notMatch('', /ize/)).to eq nil
        expect(Asserter.new('Empathise').notMatch('', /^path/)).to eq nil
      end

      it 'raises an exception when the assertion is false' do
        expect { Asserter.new('Empathise').notMatch('', /path/) }
          .to raise_exception Failure,
                              'Expected "Empathise" not to match /path/'
      end
    end
  end
end

