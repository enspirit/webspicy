module Webspicy
  class Tester
    class Result
      class OutputSchemaMet < Check

        def behavior
          "Its output meets the expected data schema"
        end

        def must?
          !test_case.is_expected_status?(204)
        end

        def call
          output = invocation.loaded_body
          service.output_schema.dress(output)
        rescue Finitio::TypeError => ex
          _! "Invalid output: #{ex.message}"
        end

      end # class OutputSchemaMet
    end # class Result
  end # class Tester
end # module Webspicy
