require 'spec_helper'

module Webspicy
  class Tester
    describe Asserter do
      let(:asserter) { Asserter.new(target) }

      describe '#size' do
        let(:target) { [1, 2, 3, 4] }

        it 'returns nil when the assertion is true for a plain array' do
          expect(asserter.size('', 4)).to eq nil
        end

        it 'raises an exception with a descriptive message when the assertion is false' do
          expect { asserter.size('', 3) }
            .to raise_exception RuntimeError, 'Expected [1,2,3,4] to have a size of 3, actual size is: 4'
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
              .to raise_exception RuntimeError,
                                  'Expected [10,11,12] to have a size of 99, actual size is: 3'
          end

          it 'raises an InvalidArgError when the path is invalid' do
            expect { asserter.size('foo/28/bar', 99) }
              .to raise_exception Webspicy::Tester::Assertions::InvalidArgError,
                                  'Expecting instance responding to size'
          end
        end
      end
    end
  end
end

