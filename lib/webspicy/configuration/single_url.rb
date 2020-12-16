module Webspicy
  class Configuration
    class SingleUrl

      class SingleUrlScope < Scope

        def initialize(config, url)
          super(config)
          @url = url
        end
        attr_reader :url

        def each_specification(&bl)
          return enum_for(:each_specification) unless block_given?
          yield Webspicy.specification(<<~YML, nil, self)
          ---
          name: |-
            Default specification
          url: |-
            #{url}
          services:
          - method: |-
              GET
            description: |-
              Getting #{url}
            input_schema: |-
              .
            output_schema: |-
              .
            error_schema: |-
              .
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
