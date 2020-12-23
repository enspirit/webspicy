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
require_relative 'client/support'
require_relative 'client/http_client'
require_relative 'client/rack_test_client'
