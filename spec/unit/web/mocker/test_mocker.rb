require 'spec_helper'
require 'rack/test'
require 'webspicy/web'
require 'webspicy/web/mocker'
module Webspicy
  module Web
    describe Mocker do
      include Rack::Test::Methods

      let(:app) {
        Mocker.new(Configuration.dress(restful_folder))
      }

      it 'works as expected' do
        get '/todo/'
        expect(last_response.status).to eql(200)
        expect(last_response.body).not_to be_empty
      end

      it 'supports CORS on OPTIONS' do
        options '/todo/'
        expect(last_response.status).to eql(204)
        expect(last_response.body).to be_empty
      end

      it 'returns the correct status code, taken from first example' do
        delete '/todo/1'
        expect(last_response.status).to eql(204)
        expect(last_response.body).to be_empty
        expect(last_response["Content-Type"]).to be_nil
      end

    end
  end
end
