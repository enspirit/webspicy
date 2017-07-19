require 'spec_helper'
module Webspicy
  describe Scope, 'each_resource' do

    with_scope_management

    let(:scope) {
      Scope.new(configuration)
    }

    subject {
      scope.each_resource.to_a
    }

    context 'without any filter' do

      let(:configuration) {
        Configuration.new{|c|
          c.add_folder restful_folder
        }
      }

      it 'returns all files' do
        expect(subject.size).to eql(restful_folder.glob('**/*.yml').size)
      end
    end

    context 'with a file filter as a proc' do

      let(:configuration) {
        Configuration.new{|c|
          c.add_folder restful_folder
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
        Configuration.new{|c|
          c.add_folder restful_folder
          c.file_filter = /getTodo.yml/
        }
      }

      it 'returns only that file' do
        expect(subject.size).to eql(1)
      end
    end

  end
end
