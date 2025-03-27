module Webspicy
  module Web
    module Openapi
      class Reporter < Webspicy::Tester::Reporter
        include Utils

        def initialize(base, output_file)
          @base = base
          @output_file = output_file
        end

        def before_all
          @datastruct = DataStruct.new
        end

        def after_each
          @datastruct.ensure_tags(tags_for(specification))
          @datastruct.ensure_path(base_path_for(specification))
          @datastruct.ensure_path(base_verb_for(test_case))
          @datastruct.ensure_path(base_request_body_for(service))
          @datastruct.ensure_path(base_request_example_for(test_case))
          @datastruct.ensure_path(base_request_response_for(invocation))
        end

        def report
          json = DataStruct::MERGER.deep_merge(
            @base,
            @datastruct.to_openapi_data,
          )
          order = ["get", "post", "patch", "delete"]
          json["paths"].keys.each do |path|
            sorted = {}
            json["paths"][path]
              .keys
              .sort_by{|k| order.index(k) || -1 }
              .each do |k|
                sorted[k] = json["paths"][path][k]
              end
            json["paths"][path] = sorted
          end
          @output_file.write(JSON.pretty_generate(json))
        end

      end # class Reporter
    end # class OpenApi
  end # class Web
end # module Webspicy
