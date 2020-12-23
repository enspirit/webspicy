module Webspicy
  class Tester
    class Result
      class ResponseHeaderMet < Check

        def initialize(result, header, expected)
          super(result)
          @header = header
          @expected = expected
        end
        attr_reader :header, :expected

        def behavior
          "It has a `#{header}: #{expected}` response header"
        end

        def must?
          true
        end

        def call
          got = response.headers[header]
          if got.nil?
            _! "Expected response header `#{header}` to be set"
          elsif expected != got
            _! "Expected response header `#{header}` to be `#{expected}`, got `#{got}`"
          end
        end

      end # class ResponseHeaderMet
    end # class Result
  end # class Tester
end # module Webspicy
