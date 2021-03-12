module Webspicy
  class Specification
    # Deprecated, use Post instead
    module Postcondition
      include Condition

      def self.match(service, descr)
      end

      def instrument(test_case, client)
      end

      def check(invocation)
      end

    end # module Postcondition
  end # module Specification
end # module Webspicy
