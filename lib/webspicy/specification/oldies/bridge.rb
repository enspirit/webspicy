module Webspicy
  class Specification
    module Oldies
      class Bridge
        include Condition

        def initialize(target)
          @target = target
        end
        attr_reader :target

        def instrument
          target.instrument(test_case, client)
        end

        def check!
          target.check(invocation)
        end

        def to_s
          "#{target} (backward compatibility bridge)"
        end

      end # class Bridge
    end # module Errcondition
  end # module Specification
  Precondition = Specification::Precondition
  Postcondition = Specification::Postcondition
end # module Webspicy
