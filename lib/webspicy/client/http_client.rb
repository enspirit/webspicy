module Webspicy
  class HttpClient < Client

    def call(test_case, service, resource)
      # Instantiate the parameters
      headers = test_case.headers
      params = test_case.dress_params? ? service.dress_params(test_case.params) : test_case.params

      # Instantiate the url and strip parameters
      url, params = resource.instantiate_url(params)

      # Globalize the URL if required
      url = scope.to_real_url(url)

      # Invoke the service now
      api = Api.new
      api.public_send(service.method.to_s.downcase.to_sym, url, params, headers)

      # Return the result
      Resource::Service::Invocation.new(service, test_case, api.last_response)
    end

    class Api

      attr_reader :last_response

      def get(url, params, headers = nil)
        headers, url = headers_and_url_for(url, params, headers)

        Webspicy.info("GET #{url} -- #{params.inspect}")

        @last_response = HTTP[headers].get(url, params: params)

        Webspicy.debug("Headers: #{@last_response.headers.to_hash}")
        Webspicy.debug("Response: #{@last_response.body}")
      end

      def post(url, params, headers = nil)
        headers, url = headers_and_url_for(url, params, headers)

        Webspicy.info("POST #{url} -- #{params.inspect}")

        @last_response = HTTP[headers].post(url, body: params.to_json)

        Webspicy.debug("Headers: #{@last_response.headers.to_hash}")
        Webspicy.debug("Response: #{@last_response.body}")
      end

      def post_form(url, params, headers = nil)
        headers, url = headers_and_url_for(url, params, headers)

        Webspicy.info("POST #{url} -- #{params.inspect}")

        @last_response = HTTP[headers].post(url, form: params)

        Webspicy.debug("Headers: #{@last_response.headers.to_hash}")
        Webspicy.debug("Response: #{@last_response.body}")
      end

    private

      def headers_and_url_for(url, params, headers)
        headers = headers || {}
        [ headers, url ]
      end

    end

  end
end
