require 'spec_helper'
module Webspicy
  describe Scope, 'each_service' do

    RESTFUL_FOLDER = EXAMPLES_FOLDER/'restful'

    let(:scope) {
      Scope.new(configuration)
    }

    let(:resource) {
      scope.each_resource.first
    }

    subject {
      scope.each_service(resource).to_a
    }

    context 'without any filter' do

      let(:configuration) {
        Configuration.new{|c|
          c.add_folder RESTFUL_FOLDER
          c.file_filter = /getTodo.yml/
        }
      }

      it 'returns all services' do
        expect(subject.size).to eql(1)
      end
    end

    context 'with a service filter as a proc' do

      let(:configuration) {
        Configuration.new{|c|
          c.add_folder RESTFUL_FOLDER
          c.file_filter = /getTodo.yml/
          c.service_filter = ->(s) {
            s.method == "POST"
          }
        }
      }

      it 'returns nothing' do
        expect(subject.size).to eql(0)
      end
    end

  end
end
