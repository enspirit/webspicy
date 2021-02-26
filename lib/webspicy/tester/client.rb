module Webspicy
  class Tester
    class Client
      extend Forwardable

      def initialize(scope)
        @scope = scope
      end
      attr_reader :scope

      def_delegators :@scope, *[
        :config
      ]

      def find_and_call(method, url, mutation)
        unless tc = scope.find_test_case(method, url)
          raise Error, "No such service `#{method} #{url}`"
        end
        mutated = tc.mutate(mutation)
        instrumented = instrument(mutated)
        call(instrumented)
      end

      def instrument(test_case)
        service = test_case.service
        service.preconditions.each do |pre|
          pre.instrument(test_case, self) if pre.respond_to?(:instrument)
        end
        service.postconditions.each do |post|
          post.instrument(test_case, self) if post.respond_to?(:instrument)
        end if test_case.example?
        service.errconditions.each do |post|
          post.instrument(test_case, self) if post.respond_to?(:instrument)
        end if test_case.counterexample?
        config.listeners(:instrument).each do |i|
          i.call(test_case, self)
        end
        test_case
      end

    end # class Client
  end # class Tester
end # module Webspicy
