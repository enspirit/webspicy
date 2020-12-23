require 'spec_helper'
require 'webspicy/openapi'
require 'openapi3_parser'
module Webspicy
  module Openapi
    describe Generator do

      let(:config) {
        Configuration.new(restful_folder)
      }

      subject {
        ruby_objs = Generator.new(config).call
        JSON.parse(ruby_objs.to_json)
      }

      it 'works fine' do
        document = Openapi3Parser.load(subject)
        #puts JSON.pretty_generate(subject)
        document.errors.each do |err|
          puts err.inspect
        end unless document.errors.empty?
        expect(document.errors).to be_empty
      end

    end
  end
end
