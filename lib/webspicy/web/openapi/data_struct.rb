module Webspicy
  module Web
    module Openapi
      class DataStruct

        MERGER = Support::DeepMerge.new({
          uniq_on_arrays: true
        })

        def initialize
          @info = {}
          @tags = []
          @paths = {}
        end
        attr_reader :info, :tags, :paths

        def ensure_tags(tags)
          @tags = (@tags + tags).uniq.sort_by{|t| t[:name] }
        end

        def ensure_path(path)
          @paths = MERGER.deep_merge(
            @paths,
            path,
          )
        end

        def to_openapi_data
          {
            "openapi" => '3.0.2',
            "info" => info,
            "tags" => tags,
            "paths" => paths,
          }
        end

      end # class DataStruct
    end # module Openapi
  end # module Web
end # module Webspicy
