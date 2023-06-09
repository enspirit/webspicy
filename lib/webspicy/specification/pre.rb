module Webspicy
  class Specification
    module Pre
      include Condition

      # Instrument the current test_case so as to meet the precondition
      def instrument
      end

      # Provide counterexamples of this precondition for a given service.
      def counterexamples(service)
        []
      end

    end # module Pre
  end # class Specification
end # module Webspicy
