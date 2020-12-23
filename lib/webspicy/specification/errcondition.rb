module Webspicy
  class Specification
    module Errcondition
      include Condition

      def self.match(service, descr)
      end

      def instrument(test_case, client)
      end

      def check(invocation)
      end

    end # module Errcondition
  end # module Specification
end # module Webspicy
