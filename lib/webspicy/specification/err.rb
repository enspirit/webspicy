module Webspicy
  class Specification
    module Err
      include Condition

      # Instrument the current test_case so as to prepare for errcondition
      # check later
      def instrument
      end

      # Check that the errcondition is met on last invocation & result
      # of an counterexample
      def check!
      end

    end # module Err
  end # module Specification
end # module Webspicy
