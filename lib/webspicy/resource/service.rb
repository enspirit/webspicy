module Webspicy
  class Resource
    class Service

      def initialize(raw)
        @raw = raw
      end

      def self.info(raw)
        new(raw)
      end

      def method
        @raw[:method]
      end

      def examples
        @raw[:examples]
      end

      def counterexamples
        @raw[:counterexamples]
      end

      def input_schema
        @raw[:input_schema]
      end

      def output_schema
        @raw[:output_schema]
      end

      def error_schema
        @raw[:error_schema]
      end

      def dress_params(params)
        input_schema.dress(params)
      end

      def to_info
        @raw
      end

    end # class Service
  end # class Resource
end # module Webspicy
require_relative 'service/test_case'
require_relative 'service/invocation'
