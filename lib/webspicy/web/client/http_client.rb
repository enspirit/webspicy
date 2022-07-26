module Webspicy
  module Web
    class HttpClient < Client

      class ::HTTP::Request

        # We monkey patch the URI normalization on Http because
        # we don't want it to interfere with URIs that are encoded
        # in tests, especially security tests.
        def normalize_uri(uri)
          uri
        end

      end # class ::HTTP::Request

      def initialize(scope)
        super(scope)
        @api = Api.new(scope)
      end
      attr_reader :api

      def _call(test_case)
        service, specification = test_case.service, test_case.specification

        # Instantiate the parameters
        headers = test_case.headers
        params  = test_case.dress_params? ? service.dress_params(test_case.params) : test_case.params
        body    = test_case.body || test_case.located_file_upload

        # Instantiate the url and strip parameters
        url, params = specification.instantiate_url(params)

        # Globalize the URL if required
        url = scope.to_real_url(url, test_case)

        # Invoke the service now
        api.public_send(service.method.to_s.downcase.to_sym, url, params, headers, body)

        # Return the response
        api.last_response
      end

      class Api
        include Client::Support

        def initialize(scope)
          @scope = scope
        end
        attr_reader :last_response

        def config
          @scope.config
        end

        def options(url, params = {}, headers = nil, body = nil)
          info_request("OPTIONS", url, params, headers, body)

          url = url + "?" + Rack::Utils.build_query(params) if !params.empty?
          http_opts = http_options
          @last_response = HTTP[headers || {}].options(url, http_opts)

          debug_response(@last_response)

          @last_response
        end

        def get(url, params = {}, headers = nil, body = nil)
          info_request("GET", url, params, headers, body)

          url = url + "?" + Rack::Utils.build_query(params) if !params.empty?
          http_opts = http_options
          @last_response = HTTP[headers || {}].get(url, http_opts)

          debug_response(@last_response)

          @last_response
        end

        def post(url, params = {}, headers = nil, body = nil)
          info_request("POST", url, params, headers, body)

          url = url + "?" + Rack::Utils.build_query(params) if body && !params.empty?

          headers ||= {}

          case body
          when NilClass
            headers['Content-Type'] ||= 'application/json'
            http_opts = http_options(body: params.to_json)
            @last_response = HTTP[headers].post(url, http_opts)
          when FileUpload
            file = HTTP::FormData::File.new(body.path.to_s, {
              content_type: body.content_type,
              filename: body.path.basename.to_s
            })
            http_opts = http_options(form: {
              body.param_name.to_sym => file
            })
            @last_response = HTTP[headers].post(url, http_opts)
          else
            headers['Content-Type'] ||= 'application/json'
            http_opts = http_options(body: body)
            @last_response = HTTP[headers].post(url, http_opts)
          end

          debug_response(@last_response)

          @last_response
        end

        def patch(url, params = {}, headers = nil, body = nil)
          info_request("PATCH", url, params, headers, body)

          url = url + "?" + Rack::Utils.build_query(params) if body && !params.empty?
          headers ||= {}
          headers['Content-Type'] ||= 'application/json'
          http_opts = http_options(body: params.to_json)
          @last_response = HTTP[headers].patch(url, http_opts)

          debug_response(@last_response)

          @last_response
        end

        def put(url, params = {}, headers = nil, body = nil)
          info_request("PUT", url, params, headers, body)

          url = url + "?" + Rack::Utils.build_query(params) if body && !params.empty?
          headers ||= {}
          headers['Content-Type'] ||= 'application/json'
          http_opts = http_options(body: params.to_json)
          @last_response = HTTP[headers].put(url, http_opts)

          debug_response(@last_response)

          @last_response
        end

        def post_form(url, params = {}, headers = nil, body = nil)
          info_request("POST", url, params, headers, body)

          url = url + "?" + Rack::Utils.build_query(params) if body && !params.empty?
          http_opts = http_options(form: params)
          @last_response = HTTP[headers || {}].post(url, http_opts)

          debug_response(@last_response)

          @last_response
        end

        def delete(url, params = {}, headers = nil, body = nil)
          info_request("DELETE", url, params, headers, body)

          url = url + "?" + Rack::Utils.build_query(params) if body && !params.empty?
          http_opts = http_options(body: params.to_json)
          @last_response = HTTP[headers || {}].delete(url, http_opts)

          debug_response(@last_response)

          @last_response
        end

        def http_options(extra = {})
          if config.insecure
            ctx = OpenSSL::SSL::SSLContext.new
            ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
            {
              :ssl_context => ctx
            }.merge(extra)
          else
            extra
          end
        end
      end # class Api

    end # class HttpClient
  end # module Web
end # module Webspicy
