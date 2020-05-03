module Webspicy
  class Resource
    class Service

      def initialize(raw)
        @raw = raw
        bind_examples
        bind_counterexamples
        @preconditions = compile_preconditions
        @postconditions = compile_postconditions
      end
      attr_accessor :resource

      def self.info(raw)
        new(raw)
      end

      def method
        @raw[:method]
      end

      def preconditions
        @preconditions
      end

      def has_preconditions?
        !preconditions.empty?
      end

      def postconditions
        @postconditions
      end

      def has_postconditions?
        !postconditions.empty?
      end

      def default_example
        @raw[:default_example]
      end

      def examples
        @raw[:examples]
      end

      def counterexamples
        @raw[:counterexamples]
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

      def to_info
        @raw
      end

      def to_s
        "#{method} #{resource.url}"
      end

    private

      def scope
        Webspicy.current_scope
      end

      def compile_preconditions
        @raw[:preconditions] = [@raw[:preconditions]] if @raw[:preconditions].is_a?(String)
        compile_conditions(@raw[:preconditions] ||= [], scope.preconditions)
      end

      def compile_postconditions
        @raw[:postconditions] = [@raw[:postconditions]] if @raw[:postconditions].is_a?(String)
        compile_conditions(@raw[:postconditions] ||= [], scope.postconditions)
      end

      def compile_conditions(descriptions, conditions)
        descriptions
          .map{|descr|
            conditions.map{|c| c.match(self, descr) }.compact
          }
          .flatten
      end

      def bind_examples
        (@raw[:examples] ||= []).each do |ex|
          ex.bind(self, false)
        end
      end

      def bind_counterexamples
        (@raw[:counterexamples] ||= []).each do |ex|
          ex.bind(self, true)
        end
      end

    end # class Service
  end # class Resource
end # module Webspicy
require_relative 'service/test_case'
require_relative 'service/invocation'
