module Webspicy
  class Specification
    module Postcondition
      class UnexpectedConditionImpl
        include Post

        def check!
          msg = matching_description.gsub(/\( \)/, "<x>")
          fail!("#{msg} (is instrumented)")
        end

      end # class UnexpectedConditionImpl
    end # module Postcondition
  end # class Specification
end # module Webspicy
