module Webspicy
  class Specification
    module Postcondition
      class MissingConditionImpl
        include Postcondition

        def check(invocation)
          msg = matching_description.gsub(/\(x\)/, "<!>")
          raise "#{msg} (not instrumented)"
        end

      end # class MissingConditionImpl
    end # module Postcondition
  end # class Specification
end # module Webspicy
