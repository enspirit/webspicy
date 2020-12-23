module Webspicy
  class Tester
    class Reporter
      class ErrorCount < Reporter

        def initialize(*args, &bl)
          super
          @error_count = 0
        end

        def on_error(*args, &bl)
          @error_count += 1
        end
        alias :spec_file_error :on_error
        alias :check_failure   :on_error
        alias :check_error     :on_error

        def report
          @error_count
        end

      end # class ErrorCount
    end # class Reporter
  end # class Tester
end # module Webspicy
