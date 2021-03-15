module Webspicy
  module Web
    class Specification
      class Service < Webspicy::Specification::Service

        def method
          @raw[:method]
        end

        def to_s
          "#{method} #{specification.url}"
        end

      end # class Service
    end # class Specification
  end # module Web
end # module Webspicy
