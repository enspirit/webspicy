require 'spec_helper'
module Webspicy
  class Configuration
    describe Scope, 'to_real_url' do

      let(:scope) {
        Scope.new(configuration)
      }

      context 'when no host at all' do

        let(:configuration) {
          Configuration.new
        }

        it 'does nothing on absolute URLs already' do
          url = 'http://127.0.0.1:4567/todo'
          got = scope.to_real_url(url)
          expect(got).to eql(url)
        end

        it 'yields the block relative URLs' do
          got = scope.to_real_url("/todo"){ "hello" }
          expect(got).to eql("hello")
        end

        it 'fails on relative URLs and no block is given' do
          expect(->(){
            scope.to_real_url("/todo")
          }).to raise_error(/Unable to resolve `\/todo`/)
        end
      end

      context 'with a static host' do

        let(:configuration) {
          Configuration.new do |c|
            c.host = "http://127.0.0.1:4568"
          end
        }

        it 'does nothing on absolute URLs already' do
          url = 'http://127.0.0.1:4567/todo'
          got = scope.to_real_url(url)
          expect(got).to eql(url)
        end

        it 'resolves relative URLs as expected' do
          url = '/todo'
          got = scope.to_real_url(url)
          expect(got).to eql("http://127.0.0.1:4568/todo")
        end

      end

      context 'with a dynamic host resolver' do

        let(:configuration) {
          Configuration.new do |c|
            c.host = ->(url, tc) {
              "http://127.0.0.1:4568#{url}"
            }
          end
        }

        it 'resolves absolute URLs' do
          url = 'http://127.0.0.1:4567/todo'
          got = scope.to_real_url(url)
          expect(got).to eql("http://127.0.0.1:4568#{url}")
        end

        it 'resolves relative URLs as expected' do
          url = '/todo'
          got = scope.to_real_url(url)
          expect(got).to eql("http://127.0.0.1:4568/todo")
        end

      end

    end
  end
end
