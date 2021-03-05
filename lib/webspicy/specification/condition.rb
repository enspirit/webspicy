module Webspicy
  class Specification
    module Condition

      MATCH_ALL = "__all__"

      attr_accessor :matching_description

      def to_s
        if matching_description == MATCH_ALL
          self.class.name
        else
          matching_description
        end
      end

      def sooner_or_later(*args, &bl)
        Webspicy::Support.sooner_or_later(*args, &bl)
      end

    end # module Condition
  end # class Specification
end # module Webspicy
