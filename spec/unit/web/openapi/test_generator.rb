require 'spec_helper'
require 'webspicy/web'
require 'webspicy/web/openapi'
require 'openapi3_parser'
module Webspicy
  module Web
    module Openapi
      describe Generator do
        let(:config) do
          Configuration.new(restful_folder)
        end

        subject do
          ruby_objs = Generator.new(config).call(info)
          JSON.parse(ruby_objs.to_json)
        end

        let(:info) do
          {}
        end

        def openapi_document
          puts JSON.pretty_generate(subject)
          document = Openapi3Parser.load(subject)
          document.errors.each do |err|
            puts err.inspect
          end unless document.errors.empty?
          document
        end

        it 'works fine' do
          expect(openapi_document.errors).to be_empty
          expect(openapi_document.info.title).to eql('Webspicy Specification')
        end

        describe 'when passing specific info' do
          let(:info) {
            {
              version: '1.1.1',
              title: 'Webspicy API'
            }
          }

          it 'takes it into account' do
            expect(openapi_document.errors).to be_empty
            expect(openapi_document.info.title).to eql('Webspicy API')
            expect(openapi_document.info.version).to eql('1.1.1')
          end
        end

      end
    end
  end
end
