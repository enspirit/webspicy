module Webspicy
  class Tester
    class Result
      class ResponseStatusMet < Check

        def behavior
          "It has a %d response status" % [ test_case.expected_status ]
        end

        def must?
          test_case.has_expected_status?
        end

        def call
          actual = response.status
          expected = test_case.expected_status
          unless expected === actual
            _!("Expected response status to be #{expected}, got #{actual}")
          end
        end

      end # class ResponseStatusMet
    end # class Result
  end # class Tester
end # module Webspicy
