module Webspicy
  class Configuration
    class SingleUrl < Configuration

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
                  content_type: text/html
                  status: 200
          YML
        end

      end # class SingleUrlScope

      def initialize(url)
        super()
        @url = url
      end

      def factor_scope
        SingleUrlScope.new(self, @url)
      end

    end # class SingleUrl
  end # class Configuration
end # module Webspicy
