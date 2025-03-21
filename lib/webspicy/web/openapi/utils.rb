module Webspicy
  module Web
    module Openapi
      module Utils

        def into_specification_path(specification, x)
          {
            standardize(specification.url) => x.compact,
          }
        end

        def into_service_verb(service, x)
          verb = downcase_verb(service)
          into_specification_path(service.specification, {
            verb => x.compact,
          })
        end

        def into_service_request_body(service, x)
          into_service_verb(service, {
            requestBody: x.compact,
          })
        end

        def into_service_responses(service, x)
          into_service_verb(service, {
            responses: x.compact,
          })
        end

        ###

        def base_path_for(specification)
          into_specification_path(specification, {
            summary: specification.name.to_s || 'API Specification'
          })
        end

        def base_verb_for(service)
          verb_defn = {
            summary: service.name,
            description: service.description,
            tags: tags_for(service.specification).map{|s| s[:name] },
            parameters: parameters_for(service),
          }

          verb_defn = service.conditions.inject(verb_defn) do |memo, p|
            if p.respond_to?(:contribute_to_openapi_verb)
              p.contribute_to_openapi_verb(memo)
            else
              memo
            end
          end

          into_service_verb(service, verb_defn)
        end

        def extract_request_body_info_for(service)
          verb = downcase_verb(service)
          return nil if ['get', 'options', 'head'].include?(verb)

          schema = actual_body_schema(service)
          return nil if empty_schema?(schema)
          puts schema.inspect

          content_type = content_type_for(service)

          [schema, content_type]
        end

        def base_request_body_for(service)
          schema, content_type = extract_request_body_info_for(service)
          return {} unless schema

          into_service_request_body(service, {
            required: true,
            content: {
              content_type => {
                schema: schema.to_json_schema,
              }.compact,
            },
          })
        end

        def base_request_example_for(test_case)
          schema, content_type = extract_request_body_info_for(service)
          return {} unless schema

          value = test_case.params
          in_url = service.specification.url_placeholders
          value = value.reject{|k,v| in_url.include?(k) } if value.is_a?(Hash)

          example = {
            description: test_case.description,
            value: value,
          }

          into_service_request_body(service, {
            required: true,
            content: {
              content_type => {
                examples: {
                  test_case.description => example
                }
              }.compact,
            },
          })
        end

        def base_request_response_for(invocation)
          test_case = invocation.test_case
          service = invocation.service
          content_type = content_type_for(service)
          verb = downcase_verb(service)

          content = nil
          unless invocation.is_empty_response?
            schema = actual_output_schema(test_case, false)
            example = invocation.loaded_output
            content = {
              content_type => {
                schema: schema&.to_json_schema,
                example: example,
              }.compact
            }
          end

          into_service_responses(service, {
            invocation.response_code.to_s => {
              description: '',
              content: content,
            }.compact
          })
        end

        def tags_for(specification)
          tag = specification&.openapi&.[](:tag) || specification.name

          return [] unless tag.is_a?(String)
          return [] if tag.empty?

          [{
            name: tag.gsub(/\n/, ' ').strip
          }]
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

        def actual_body_schema(service)
          schema = actual_input_schema(service)

          a_schema = schema
          a_schema = schema.target if schema.is_a?(Finitio::AliasType)
          return schema unless a_schema.is_a?(Finitio::HashBasedType)

          in_url = service.specification.url_placeholders.map(&:to_sym)
          return schema if in_url.empty?

          a_schema.allbut(in_url)
        end

        def standardize(url)
          url = url.gsub(/\/$/, '') if url =~ /\/$/
          url
        end

        def downcase_verb(service)
          service.method.downcase.gsub(/_form$/, '')
        end

        def content_type_for(service)
          if service.method.downcase == 'post_form'
            'application/x-www-form-urlencoded'
          else
            'application/json'
          end
        end

        def empty_schema?(schema)
          schema = schema.target if schema.is_a?(Finitio::AliasType)
          schema.is_a?(Finitio::HashBasedType) && schema.heading.empty?
        end

      end # module Utils
    end # module Openapi
  end # module Web
end # module Webspicy
