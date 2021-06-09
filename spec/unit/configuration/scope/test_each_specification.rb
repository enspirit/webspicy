require 'spec_helper'
module Webspicy
  class Configuration
    describe Scope, 'each_specification' do

      let(:scope) {
        Scope.new(configuration)
      }

      subject {
        scope.each_specification.to_a
      }

      context 'without any filter' do

        let(:configuration) {
          Configuration.new(restful_folder)
        }

        it 'returns all files' do
          expect(subject.size).to eql(restful_folder.glob('**/*.{yml, yaml}').size)
        end
      end

      context 'with a file filter as a proc' do

        let(:configuration) {
          Configuration.new(restful_folder){|c|
            c.file_filter = ->(f) {
              f.basename.to_s == "get.yml"
            }
          }
        }

        it 'returns only that files' do
          expect(subject.size).to eql(2)
        end
      end

      context 'with a file filter as a Regex' do

        let(:configuration) {
          Configuration.new(restful_folder){|c|
            c.file_filter = /get.yml/
          }
        }

        it 'returns only that files' do
          expect(subject.size).to eql(2)
        end
      end

      context 'when having children folders' do

        let(:configuration) {
          Configuration.new(restful_folder) do |c|
            c.folder 'formaldef/todo'
          end
        }

        it 'returns all files' do
          expect(subject.size).to eql(restful_folder.glob('**/*.{yml, yaml}').size)
        end
      end

    end
  end
end
