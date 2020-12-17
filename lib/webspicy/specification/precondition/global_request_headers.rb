module Webspicy
  class Specification
    module Precondition
      class GlobalRequestHeaders
        include Precondition

        DEFAULT_OPTIONS = {}

        def initialize(headers, options = {}, &bl)
          @headers = headers
          @options = DEFAULT_OPTIONS.merge(options)
          @matcher = bl
        end
        attr_reader :headers, :matcher

        def match(service, pre)
          if matcher
            return self if matcher.call(service)
            nil
          else
            self
          end
        end

        def instrument(test_case, client)
          extra = headers.reject{|k|
            test_case.headers.has_key?(k)
          }
          test_case.headers.merge!(extra)
        end

      end # class GlobalRequestHeaders
    end # module Precondition
  end # class Specification
end # module Webspicy
