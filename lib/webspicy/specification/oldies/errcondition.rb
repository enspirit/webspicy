module Webspicy
  class Specification
    # Deprecated, use Err instead
    module Errcondition
      include Condition

      def bind(tester)
        Oldies::Bridge.new(self).bind(tester)
      end

      def self.match(service, descr)
      end

      def instrument(test_case, client)
      end

      def check(invocation)
      end

    end # module Errcondition
  end # module Specification
end # module Webspicy
