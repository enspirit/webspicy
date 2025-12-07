require 'spec_helper'
require 'rack/test'
require 'webspicy/web'
require 'webspicy/web/inferer'
module Webspicy
  module Web
    describe Inferer do
      include Rack::Test::Methods

      let(:config) {
        Configuration.dress(restful_folder)
      }

      let(:options) {{
        :target_endpoint => "https://reqres.in/api"
      }}

      let(:app) {
        Inferer.new(config, options)
      }

      describe 'proxy_options' do
        it 'works' do
          expect(app.send(:proxy_options)).to eql({
            :streaming => false,
            :backend => "https://reqres.in"
          })
        end
      end

      describe 'static_env' do
        it 'works' do
          expect(app.send(:static_env)).to eql({
            "HTTP_HOST" => "reqres.in"
          })
        end
      end

      # describe 'the proxy itself' do
      #   it 'works as expected' do
      #     get '/users'
      #     expect(last_response.status).to eql(200)
      #     expect(last_response.body).not_to be_empty
      #   end
      # end

    end
  end
end
