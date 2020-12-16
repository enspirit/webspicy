require "finitio/generation"
require "finitio/json_schema"
module Webspicy
  module Openapi
    class Generator

      def initialize(config)
        @config = Configuration.dress(config)
        @generator = config.generator || Finitio::Generation.new
      end
      attr_reader :config, :generator

      def call
        {
          openapi: "3.0.2",
          info: {
            version: "1.0.0",
            title: "Hello API"
          },
          paths: paths
        }
      end

    private

      def paths
        config.each_scope.inject({}) do |paths,scope|
          scope.each_specification.inject(paths) do |paths,specification|
            paths.merge(path_for(specification)){|k,ps,qs|
              ps.merge(qs)
            }
          end
        end
      end

      def path_for(specification)
        {
          specification.url => {
            summary: specification.name
          }.merge(verbs_for(specification))
        }
      end

      def verbs_for(specification)
        specification.services.inject({}) do |verbs,service|
          verb = service.method.downcase
          verb_defn = {
            description: service.description,
            responses: responses_for(service)
          }
          unless ["get", "options", "delete", "head"].include?(verb)
            verb_defn[:requestBody] = request_body_for(service)
          end
          verbs.merge({ verb => verb_defn })
        end
      end

      def request_body_for(service)
        schema = actual_input_schema(service)
        {
          required: true,
          content: {
            "application/json" => {
              schema: schema.to_json_schema,
              example: generator.call(schema, {})
            }
          }
        }
      end

      def responses_for(service)
        result = {}
        service.examples.each_with_object(result) do |test_case, rs|
          rs.merge!(response_for(test_case, false)){|k,r1,r2| r1 }
        end
        service.counterexamples.each_with_object(result) do |test_case, rs|
          rs.merge!(response_for(test_case, true)){|k,r1,r2| r1 }
        end
        result
      end

      def response_for(test_case, counterexample)
        res = {
          description: test_case.description,
        }
        status = (test_case.expected_status && test_case.expected_status.to_int) || 200
        if test_case.expected_content_type && status != 204
          content = {
            schema: schema_for(test_case, counterexample)
          }
          unless counterexample
            content[:example] = example_for(test_case, counterexample)
          end
          res[:content] = {
            test_case.expected_content_type => content
          }
        end
        {
          status => res
        }
      end

      def schema_for(test_case, counterexample)
        schema = actual_output_schema(test_case, counterexample)
        schema.to_json_schema
      end

      def example_for(test_case, counterexample)
        schema = actual_output_schema(test_case, counterexample)
        generator.call(schema, {})
      end

      def actual_output_schema(test_case, counterexample)
        if counterexample
          test_case.service.error_schema['Main']
        else
          test_case.service.output_schema['Main']
        end
      end

      def actual_input_schema(service)
        service.input_schema['Main']
      end

    end # class Generator
  end # module Openapi
end # module Webspicy
