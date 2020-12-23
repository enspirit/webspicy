module Webspicy
  class Tester
    class Result
      class AssertMet < Check

        def initialize(result, assertion)
          super(result)
          @assertion = assertion
        end
        attr_reader :assertion

        def behavior
          "Assert #{assertion}"
        end

        def must?
          true
        end

        def call
          on = invocation.dressed_body
          asserter = Tester::Asserter.new(on)
          asserter.instance_eval(assertion)
        end

      end # class AssertMet
    end # class Result
  end # class Tester
end # module error
