module Webspicy
  module Web
    class Specification
      class Service < Webspicy::Specification::Service

        def method
          @raw[:method]
        end

      end # class Service
    end # class Specification
  end # module Web
end # module Webspicy
