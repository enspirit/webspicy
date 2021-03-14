module Webspicy
  module Web
    class Specification
      class FileUpload

        def initialize(raw)
          @path = raw[:path]
          @content_type = raw[:content_type]
          @param_name = raw[:param_name] || "file"
        end

        attr_reader :path, :content_type, :param_name

        def self.info(raw)
          new(raw)
        end

        def locate(specification)
          FileUpload.new({
            path: specification.locate(path),
            content_type: content_type
          })
        end

        def to_info
          { path: path.to_s,
            content_type: content_type,
            param_name: param_name }
        end

        def to_s
          "FileUpload(#{to_info})"
        end
        alias :inspect :to_s

      end # class FileUpload
    end # class Specification
  end # module Web
end # module Webspicy
