module Webspicy
  class Resource
    class Service

      def initialize(raw)
        @raw = raw
      end

      def self.info(raw)
        new(raw)
      end

      def method
        @raw[:method]
      end

      def examples
        @raw[:examples]
      end

      def counterexamples
        @raw[:counterexamples]
      end

      def input_schema
        @raw[:input_schema]
      end

      def output_schema
        @raw[:output_schema]
      end

      def error_schema
        @raw[:error_schema]
      end

      def dress_params(params)
        input_schema.dress(params)
      end

      def invoke_on(api, resource, test_case, scope)
        # Instantiate the parameters
        headers = test_case.headers
        params = test_case.dress_params? ? dress_params(test_case.params) : test_case.params

        # Instantiate the url and strip parameters
        url, params = resource.instantiate_url(params)

        # Globalize the URL if required
        url = scope.to_real_url(url)

        # Invoke the service now
        api.public_send(method.to_s.downcase.to_sym, url, params, headers)

        # Return the result
        Invocation.new(self, test_case, api.last_response)
      end

      def to_info
        @raw
      end

    end # class Service
  end # class Resource
end # module Webspicy
require_relative 'service/test_case'
require_relative 'service/invocation'
