module Webspicy
  class Specification
    module Post
      include Condition

      # Instrument the current test_case so as to prepare for postcondition
      # check later
      def instrument
      end

      # Check that the postcondition is met on last invocation & result
      # of an example
      def check!
      end

    end # module Post
  end # module Specification
end # module Webspicy
require_relative "post/missing_condition_impl"
require_relative "post/unexpected_condition_impl"
