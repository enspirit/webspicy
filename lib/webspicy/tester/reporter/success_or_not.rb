module Webspicy
  class Tester
    class Reporter
      class SuccessOrNot < Summary

        def report
          total_error_count
        end

      end # class SuccessOrNot
      ErrorCount = SuccessOrNot # for backward compatibility
    end # class Reporter
  end # class Tester
end # module Webspicy
