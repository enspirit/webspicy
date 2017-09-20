module Webspicy
  class HttpClient < Client

    def initialize(scope)
      super(scope)
      @api = Api.new
    end
    attr_reader :api

    def call(test_case)
      service, resource = test_case.service, test_case.resource

      # Instantiate the parameters
      headers = test_case.headers
      params = test_case.dress_params? ? service.dress_params(test_case.params) : test_case.params

      # Instantiate the url and strip parameters
      url, params = resource.instantiate_url(params)

      # Globalize the URL if required
      url = scope.to_real_url(url, to_real_url)

      # Invoke the service now
      api.public_send(service.method.to_s.downcase.to_sym, url, params, headers, test_case.body)

      # Return the result
      Resource::Service::Invocation.new(service, test_case, api.last_response, self)
    end

    class Api

      attr_reader :last_response

      def get(url, params = {}, headers = nil, body = nil)
        Webspicy.info("GET #{url} -- #{params.inspect}")

        @last_response = HTTP[headers || {}].get(url, params: params)

        Webspicy.debug("Headers: #{@last_response.headers.to_hash}")
        Webspicy.debug("Response: #{@last_response.body}")

        @last_response
      end

      def post(url, params = {}, headers = nil, body = nil)
        Webspicy.info("POST #{url} -- #{params.inspect}")

        url = url + "?" + Rack::Utils.build_query(params) if body && !params.empty?

        headers ||= {}
        headers['Content-Type'] ||= 'application/json'

        if body
          @last_response = HTTP[headers].post(url, body: body)
        else
          @last_response = HTTP[headers].post(url, body: params.to_json)
        end

        Webspicy.debug("Headers: #{@last_response.headers.to_hash}")
        Webspicy.debug("Response: #{@last_response.body}")

        @last_response
      end

      def patch(url, params = {}, headers = nil, body = nil)
        Webspicy.info("PATCH #{url} -- #{params.inspect}")

        headers ||= {}
        headers['Content-Type'] ||= 'application/json'
        @last_response = HTTP[headers].patch(url, body: params.to_json)

        Webspicy.debug("Headers: #{@last_response.headers.to_hash}")
        Webspicy.debug("Response: #{@last_response.body}")

        @last_response
      end

      def post_form(url, params = {}, headers = nil, body = nil)
        Webspicy.info("POST #{url} -- #{params.inspect}")

        @last_response = HTTP[headers || {}].post(url, form: params)

        Webspicy.debug("Headers: #{@last_response.headers.to_hash}")
        Webspicy.debug("Response: #{@last_response.body}")

        @last_response
      end

      def delete(url, params = {}, headers = nil, body = nil)
        Webspicy.info("DELETE #{url} -- #{params.inspect}")

        @last_response = HTTP[headers || {}].delete(url, body: params.to_json)

        Webspicy.debug("Headers: #{@last_response.headers.to_hash}")
        Webspicy.debug("Response: #{@last_response.body}")

        @last_response
      end

    end

  end
end
