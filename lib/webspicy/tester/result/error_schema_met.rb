module Webspicy
  class Tester
    class Result
      class ErrorSchemaMet < Check

        def behavior
          "Error data meets the expected error schema"
        end

        def must?
          test_case.has_expected_status? && \
            !test_case.is_expected_status?(204) && \
            !test_case.is_redirect_expected_status?
        end

        def call
          output = if invocation.is_structured_output?
            invocation.loaded_body
          else
            invocation.raw_output
          end
          service.error_schema.dress(output)
        rescue Finitio::TypeError => ex
          _! "Invalid error: #{ex.message}"
        end

      end # class ErrorSchemaMet
    end # class Result
  end # class Tester
end # module error
