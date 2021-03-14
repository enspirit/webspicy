module Webspicy
  class Configuration
    class SingleUrl

      class SingleUrlScope < Scope

        def initialize(config, url)
          super(config)
          @url = url
        end
        attr_reader :url

        def each_specification_file(*args, &bl)
          return enum_for(:each_specification_file) unless block_given?
          yield Path.tempfile(["specification",".yml"]).tap{|f|
            f.write(specification_src)
          }
        end

        def each_specification(*args, &bl)
          return enum_for(:each_specification) unless block_given?
          yield Webspicy.specification(specification_src, nil, self)
        end

        def specification_src
          <<~YML.tap{|s| Webspicy.debug(s) }
          ---
          description: |-
            Getting #{url}

          url: |-
            #{url}

          method: |-
            GET

          input_schema: |-
            Any

          output_schema: |-
            Any

          error_schema: |-
            Any

          examples:

            - description: |-
                it returns a 200
              params: {}
              expected:
                status: 200
          YML
        end

      end # class SingleUrlScope

      def initialize(url)
        @url = url
      end

      def call(config)
        SingleUrlScope.new(config, @url)
      end

    end # class SingleUrl
  end # class Configuration
end # module Webspicy
