module Webspicy
  class Specification
    module Postcondition
      class MissingConditionImpl
        include Post

        def check!
          msg = matching_description.gsub(/\(x\)/, "<!>")
          fail!("#{msg} (not instrumented)")
        end

      end # class MissingConditionImpl
    end # module Postcondition
  end # class Specification
end # module Webspicy
