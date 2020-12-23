module Webspicy
  module Web
    class RackTestClient < Client

      def self.for(app)
        Factory.new(app)
      end

      def initialize(scope, app)
        super(scope)
        @api = Api.new(scope, app)
      end
      attr_reader :api

      def _call(test_case)
        service, specification = test_case.service, test_case.specification

        # Instantiate the parameters
        headers = test_case.headers.dup
        params  = test_case.dress_params? ? service.dress_params(test_case.params) : test_case.params
        body    = test_case.body || test_case.located_file_upload

        # Instantiate the url and strip parameters
        url, params = specification.instantiate_url(params)
        url = scope.to_real_url(url, test_case){|u,_| u }

        # Invoke the service now
        api.public_send(service.method.to_s.downcase.to_sym, url, params, headers, body)

        # Return the last response
        api.last_response
      end

      class Factory

        def initialize(app)
          @app = app
        end
        attr_reader :app

        def new(scope)
          RackTestClient.new(scope, app)
        end

      end # class Factory

      class RackHandler
        include Rack::Test::Methods

        def initialize(app)
          @app = app
        end
        attr_reader :app

      end # class RackHandler

      class Api
        include Client::Support

        attr_reader :last_response

        def initialize(scope, app)
          @scope = scope
          @app = app
        end

        def config
          @scope.config
        end

        def options(url, params = {}, headers = nil, body = nil)
          handler = get_handler(headers)

          info_request("OPTIONS", url, params, headers, body)

          handler.options(url, params)
          @last_response = handler.last_response

          debug_response(@last_response)

          @last_response
        end

        def get(url, params = {}, headers = nil, body = nil)
          handler = get_handler(headers)

          params = Hash[params.map{|k,v| [k, v.nil? ? "" : v] }]
          info_request("GET", url, params, headers, body)

          handler.get(url, params)
          @last_response = handler.last_response

          debug_response(@last_response)

          @last_response
        end

        def post(url, params = {}, headers = nil, body = nil)
          handler = get_handler(headers)

          url = url + "?" + Rack::Utils.build_query(params) if body && !params.empty?

          case body
          when NilClass
            info_request("POST", url, params, headers, body)
            handler.post(url, params.to_json, {"CONTENT_TYPE" => "application/json"})
          when FileUpload
            file = Rack::Test::UploadedFile.new(body.path, body.content_type)
            info_request("POST", url, params, headers, body)
            handler.post(url, body.param_name.to_sym => file)
          else
            info_request("POST", url, params, headers, body)
            handler.post(url, body)
          end
          @last_response = handler.last_response

          debug_response(@last_response)

          @last_response
        end

        def patch(url, params = {}, headers = nil, body = nil)
          handler = get_handler(headers)

          info_request("PATCH", url, params, headers, body)

          handler.patch(url, params.to_json, {"CONTENT_TYPE" => "application/json"})
          @last_response = handler.last_response

          debug_response(@last_response)

          @last_response
        end

        def put(url, params = {}, headers = nil, body = nil)
          handler = get_handler(headers)

          info_request("PUT", url, params, headers, body)

          handler.put(url, params.to_json, {"CONTENT_TYPE" => "application/json"})
          @last_response = handler.last_response

          debug_response(@last_response)

          @last_response
        end

        def post_form(url, params = {}, headers = nil, body = nil)
          handler = get_handler(headers)

          info_request("POST", url, params, headers, body)

          handler.post(url, params)
          @last_response = handler.last_response

          debug_response(@last_response)

          @last_response
        end

        def delete(url, params = {}, headers = nil, body = nil)
          handler = get_handler(headers)

          info_request("DELETE", url, params, headers, body)

          handler.delete(url, params.to_json, {"CONTENT_TYPE" => "application/json"})
          @last_response = handler.last_response

          debug_response(@last_response)

          @last_response
        end

      private

        def get_handler(hs)
          handler = RackHandler.new(@app)
          hs.each_pair do |k,v|
            handler.header(k,v)
          end if hs
          handler
        end

      end # class Api

    end # class RackTestClient
  end # module Web
end # module Webspicy
