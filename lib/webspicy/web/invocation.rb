module Webspicy
  module Web
    class Invocation < Tester::Invocation

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

      def raw_output
        response.body.to_s
      end

      def loaded_output
        ct = response.content_type || test_case.expected_content_type
        ct = ct.mime_type if ct.respond_to?(:mime_type)
        case ct
        when %r{json}
          raise "Body empty while expected" if raw_output.empty?
          @loaded_output ||= ::JSON.parse(response.body)
        else
          raw_output
        end
      end
      alias :loaded_body :loaded_output

      def output
        schema = is_expected_success? ? service.output_schema : service.error_schema
        begin
          schema.dress(loaded_output)
        rescue Finitio::TypeError => ex
          ex
        end
      end
      alias :dressed_body :output
      alias :error :output

    end # class Invocation
  end # module Web
end # module Webspicy
