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

    end # class Client
  end # class Tester
end # module Webspicy
