module Webspicy
  class Specification
    # Deprecated, use Pre instead
    module Precondition
      include Condition

      def self.match(service, pre)
      end

      def instrument(test_case, client)
      end

      def counterexamples(service)
        []
      end

    end # module Precondition
  end # class Specification
end # module Webspicy
