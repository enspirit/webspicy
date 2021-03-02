module Webspicy
  class Tester
    class Result
      class ResponseHeaderMet < Check

        def initialize(result, header, expected, strategy = :eq)
          unless [:eq, :start_with].include?(strategy)
            raise ArgumentError, "Invalid strategy `#{strategy.inspect}`"
          end
          super(result)
          @header = header
          @expected = expected
          @strategy = strategy
        end
        attr_reader :header, :expected, :strategy

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
          else
            msg = "Expected response header `#{header}` to be `#{expected}`, got `#{got}`"
            case strategy
            when :eq
              _!(msg) unless expected == got
            when :start_with
              _!(msg) unless got.start_with?(expected)
            end
          end
        end

      end # class ResponseHeaderMet
    end # class Result
  end # class Tester
end # module Webspicy
