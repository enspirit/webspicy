module Webspicy
  class Specification
    class TestCase
      include Support::DataObject

      def initialize(raw)
        super(raw)
        @counterexample = nil
      end
      attr_reader :service
      attr_reader :counterexample

      def bind(service, counterexample)
        @service = service
        @counterexample = counterexample
        self
      end

      def example?
        !@counterexample
      end

      def counterexample?
        !!@counterexample
      end

      def specification
        service.specification
      end

      # Deprecated
      alias :resource :specification

      def self.info(raw)
        new(raw)
      end

      def description
        @raw[:description]
      end

      def seeds
        @raw[:seeds]
      end

      def metadata
        @raw[:metadata] ||= {}
      end

      def tags
        @raw[:tags] ||= []
      end

      def input
        service.dress_params(params)
      end

      def expected
        @raw[:expected] || {}
      end

      def expected_error
        expected[:error]
      end

      def has_expected_error?
        !expected_error.nil?
      end

      def assert
        @raw[:assert] || []
      end

      def has_assertions?
        !assert.empty?
      end

      def mutate(override)
        m = self.dup
        m.raw = self.raw.merge(override)
        m
      end

      def to_s
        description
      end

    end # class TestCase
  end # class Specification
end # module Webspicy
