module Webspicy
  class RackTestClient < Client

    def self.for(app)
      Factory.new(app)
    end

    def initialize(scope, app)
      super(scope)
      @api = Api.new(app)
    end
    attr_reader :api

    def call(test_case, service, resource)
      # Instantiate the parameters
      headers = test_case.headers
      params = test_case.dress_params? ? service.dress_params(test_case.params) : test_case.params

      # Instantiate the url and strip parameters
      url, params = resource.instantiate_url(params)

      # Invoke the service now
      api.public_send(service.method.to_s.downcase.to_sym, url, params, headers)

      # Return the result
      Resource::Service::Invocation.new(service, test_case, api.last_response)
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

      attr_reader :last_response

      def initialize(app)
        @app = app
      end

      def get(url, params = {}, headers = nil)
        handler = get_handler(headers)

        Webspicy.info("GET #{url} -- #{params.inspect} -- #{headers.inspect}")

        handler.get(url, params)
        @last_response = handler.last_response

        Webspicy.debug("Headers: #{@last_response.headers.to_hash}")
        Webspicy.debug("Response: #{@last_response.body}")
      end

      def post(url, params = {}, headers = nil)
        handler = get_handler(headers)

        Webspicy.info("POST #{url} -- #{params.inspect} -- #{headers.inspect}")

        handler.post(url, params.to_json, {"CONTENT_TYPE" => "application/json"})
        @last_response = handler.last_response

        Webspicy.debug("Headers: #{@last_response.headers.to_hash}")
        Webspicy.debug("Response: #{@last_response.body}")
      end

      def post_form(url, params = {}, headers = nil)
        handler = get_handler(headers)

        Webspicy.info("POST #{url} -- #{params.inspect} -- #{headers.inspect}")

        handler.post(url, params)
        @last_response = handler.last_response

        Webspicy.debug("Headers: #{@last_response.headers.to_hash}")
        Webspicy.debug("Response: #{@last_response.body}")
      end

      def delete(url, params = {}, headers = nil)
        handler = get_handler(headers)

        Webspicy.info("DELETE #{url} -- #{params.inspect} -- #{headers.inspect}")

        handler.delete(url, params.to_json, {"CONTENT_TYPE" => "application/json"})
        @last_response = handler.last_response

        Webspicy.debug("Headers: #{@last_response.headers.to_hash}")
        Webspicy.debug("Response: #{@last_response.body}")
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
end # module Webspicy
