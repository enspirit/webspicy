module Webspicy
  class Tester
    class Invocation
      extend Forwardable

      def initialize(test_case, response, client)
        @test_case = test_case
        @response = response
        @client = client
      end
      attr_reader :test_case, :response, :client

      def_delegators :@test_case, *[
        :config,
        :scope,
        :specification,
        :service
      ]

      ### Getters on response

      def response_code
        code = response.status
        code = code.code unless code.is_a?(Integer)
        code
      end

      ### Query methods

      def done?
        !response.nil?
      end

      def is_expected_success?
        test_case.expected_status.to_i >= 200 && test_case.expected_status.to_i < 300
      end

      def is_success?
        response_code >= 200 && response_code < 300
      end

      def is_empty_response?
        response_code == 204
      end

      def is_redirect?
        response_code >= 300 && response_code < 400
      end

      def loaded_body
        ct = response.content_type || test_case.expected_content_type
        ct = ct.mime_type if ct.respond_to?(:mime_type)
        case ct
        when %r{json}
          raise "Body empty while expected" if response.body.to_s.empty?
          @loaded_body ||= ::JSON.parse(response.body)
        else
          response.body.to_s
        end
      end

      def dressed_body
        schema = is_expected_success? ? service.output_schema : service.error_schema
        begin
          schema.dress(loaded_body)
        rescue Finitio::TypeError => ex
          ex
        end
      end

    end # class Invocation
  end # class Tester
end # module Webspicy
