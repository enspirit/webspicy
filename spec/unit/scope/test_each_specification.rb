require 'spec_helper'
module Webspicy
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
        expect(subject.size).to eql(restful_folder.glob('**/*.yml').size)
      end
    end

    context 'with a file filter as a proc' do

      let(:configuration) {
        Configuration.new(restful_folder){|c|
          c.file_filter = ->(f) {
            f.basename.to_s == "getTodo.yml"
          }
        }
      }

      it 'returns only that file' do
        expect(subject.size).to eql(1)
      end
    end

    context 'with a file filter as a Regex' do

      let(:configuration) {
        Configuration.new(restful_folder){|c|
          c.file_filter = /getTodo.yml/
        }
      }

      it 'returns only that file' do
        expect(subject.size).to eql(1)
      end
    end

    context 'when having children folders' do

      let(:configuration) {
        Configuration.new(restful_folder) do |c|
          c.folder 'todo'
        end
      }

      it 'returns all files' do
        expect(subject.size).to eql(restful_folder.glob('**/*.yml').size)
      end
    end

  end
end
