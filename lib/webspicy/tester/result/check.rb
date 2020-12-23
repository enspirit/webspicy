module Webspicy
  class Tester
    class Result
      class Check
        extend Forwardable

        def initialize(result)
          @result = result
        end
        attr_reader :result

        def_delegators :@result, *[
          :config,
          :scope,
          :client,
          :specification,
          :service,
          :test_case,
          :invocation
        ]

        def_delegators :invocation, *[
          :response
        ]

        def _!(msg)
          raise Failure, msg
        end

      end # class Check
    end # class Result
  end # class Tester
end # module Webspicy
