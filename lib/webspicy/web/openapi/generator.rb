require 'finitio/generation'
require 'finitio/json_schema'
module Webspicy
  module Web
    module Openapi
      class Generator

        DEFAULT_OPENAPI = {
          openapi: '3.0.2',
          info: {
            version: '1.0.0',
            title: 'Webspicy Specification'
          }
        }

        def initialize(config)
          @config = Configuration.dress(config)
          @generator = config.generator || Finitio::Generation.new(
            collection_size: 1..1
          )
        end
        attr_reader :config, :generator

        def call(info = {})
          base = Support::DeepMerge.deep_merge(
            DEFAULT_OPENAPI,
            base_openapi
          )
          Support::DeepMerge.deep_merge(
            base,
            {
              info: info,
              tags: tags,
              paths: paths
            }
          )
        end

      private

        def base_openapi
          file = config.folder/'openapi.base.yml'
          if file.exists?
            Support::DeepMerge.symbolize_keys(file.load)
          else
            {}
          end
        end

        def tags
          config.each_scope.inject([]) do |tags,scope|
            scope.each_specification.inject(tags) do |tags,specification|
              tags + tags_for(specification)
            end
          end.uniq.sort_by{|t| t[:name] }
        end

        def tags_for(specification)
          return [] unless specification.name.is_a?(String)
          return [] if specification.name.empty?

          [{
            name: specification.name.gsub(/\n/, ' ').strip
          }]
        end

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
            standardize(specification.url) => {
              summary: specification.name.to_s || 'API Specification'
            }.merge(verbs_for(specification))
          }
        end

        def standardize(url)
          url = url.gsub(/\/$/, '') if url =~ /\/$/
          url
        end

        def verbs_for(specification)
          specification.services.inject({}) do |verbs,service|
            verb = service.method.downcase.gsub(/_form$/, '')
            verb_defn = {
              summary: service.name,
              description: service.description,
              tags: tags_for(specification).map{|s| s[:name] },
              parameters: parameters_for(service),
              responses: responses_for(service)
            }.compact
            unless ['get', 'options', 'delete', 'head'].include?(verb)
              verb_defn[:requestBody] = request_body_for(service)
            end
            verbs.merge({ verb => verb_defn })
          end
        end

        def request_body_for(service)
          schema = actual_input_schema(service)
          example = nil # catch(:unfound) { generator.call(schema, {}) }
          {
            required: true,
            content: {
              'application/json' => {
                schema: schema.to_json_schema,
                example: example
              }.compact
            }
          }
        end

        def parameters_for(service)
          schema = actual_input_schema(service)
          params = service.specification.url_placeholders.map{|p|
            {
              in: 'path',
              name: p,
              schema: { type: 'string' },
              required: true
            }
          }
          params.empty? ? nil : params
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
  end # module Web
end # module Webspicy
