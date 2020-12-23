module Webspicy
  class Tester
    class Invocation
      extend Forwardable

      def initialize(test_case, response, client)
        @test_case = test_case
        @response = response
        @client = client
      end
      attr_reader :test_case, :response, :client

      def_delegators :@test_case, *[
        :config,
        :scope,
        :specification,
        :service
      ]

      def raw_output
        raise NotImplementedError
      end

      def loaded_output
        raise NotImplementedError
      end

      def output
        raise NotImplementedError
      end

    end # class Invocation
  end # class Tester
end # module Webspicy
