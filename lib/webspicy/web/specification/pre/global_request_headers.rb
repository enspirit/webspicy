module Webspicy
  module Web
    class Specification
      module Pre
        class GlobalRequestHeaders
          include Pre

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

          def instrument
            extra = headers.reject{|k|
              test_case.headers.has_key?(k)
            }
            puts "Instrumenting #{test_case.object_id}"
            test_case.headers.merge!(extra)
          end

        end # class GlobalRequestHeaders
      end # module Pre
    end # class Specification
  end # module Web
end # module Webspicy
