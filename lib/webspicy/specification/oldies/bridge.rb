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
          return unless target.respond_to?(:instrument)
          target.instrument(test_case, client)
        end

        def check!
          return unless target.respond_to?(:check)
          res = target.check(invocation)
          res ? fail!(res) : nil
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
