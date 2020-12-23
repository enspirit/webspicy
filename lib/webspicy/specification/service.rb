module Webspicy
  class Specification
    class Service
      include Support::DataObject

      def initialize(raw)
        super(raw)
        bind_examples
        bind_counterexamples
        @scope = Webspicy.current_scope
      end
      attr_accessor :specification

      def self.info(raw)
        new(raw)
      end

      def method
        @raw[:method]
      end

      def description
        @raw[:description]
      end

      def preconditions
        @preconditions ||= compile_preconditions
      end

      def has_preconditions?
        !preconditions.empty?
      end

      def postconditions
        @postconditions ||= compile_postconditions
      end

      def has_postconditions?
        !postconditions.empty?
      end

      def errconditions
        @errconditions ||= compile_errconditions
      end

      def has_errconditions?
        !errconditions.empty?
      end

      def default_example
        @raw[:default_example]
      end

      def examples
        @raw[:examples] || []
      end

      def counterexamples
        @raw[:counterexamples] || []
      end

      def generated_counterexamples
        preconditions.map{|pre|
          pre.counterexamples(self).map{|tc|
            tc = Webspicy.test_case(tc, Webspicy.current_scope)
            tc.bind(self, true)
          }
        }.flatten
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

      def to_s
        "#{method} #{specification.url}"
      end

    private

      def scope
        @scope
      end

      def compile_preconditions
        @raw[:preconditions] = [@raw[:preconditions]] if @raw[:preconditions].is_a?(String)
        compile_conditions(@raw[:preconditions] ||= [], scope.preconditions)
      end

      def compile_postconditions
        @raw[:postconditions] = [@raw[:postconditions]] if @raw[:postconditions].is_a?(String)
        compile_conditions(@raw[:postconditions] ||= [], scope.postconditions)
      end

      def compile_errconditions
        @raw[:errconditions] = [@raw[:errconditions]] if @raw[:errconditions].is_a?(String)
        compile_conditions(@raw[:errconditions] ||= [], scope.errconditions)
      end

      def compile_conditions(descriptions, conditions)
        # Because we want pre & post to be able to match in all cases
        # we need at least one condition
        descriptions = ["all"] if descriptions.empty?
        descriptions
          .map{|descr|
            conditions.map{|c| c.match(self, descr) }.compact
          }
          .flatten
      end

      def bind_examples
        examples.each do |ex|
          ex.bind(self, false)
        end
      end

      def bind_counterexamples
        counterexamples.each do |ex|
          ex.bind(self, true)
        end
      end

    end # class Service
  end # class Specification
end # module Webspicy
