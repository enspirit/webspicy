module Webspicy
  class Resource
    class Service
      class TestCase

        def initialize(raw)
          @raw = raw
        end

        def self.info(raw)
          new(raw)
        end

        def description
          @raw[:description]
        end

        def seeds
          @raw[:seeds] || 'test'
        end

        def headers
          @raw[:headers] || {}
        end

        def dress_params
          @raw.fetch(:dress_params){ true }
        end
        alias :dress_params? :dress_params

        def params
          @raw[:params]
        end

        def expected_content_type
          @raw[:expected][:content_type] || 'application/json'
        end

        def expected_status
          @raw[:expected][:status]
        end

        def expected_error
          @raw[:expected][:error]
        end

        def expected_headers
          @raw[:expected][:headers] || {}
        end

        def assert
          @raw[:assert] || []
        end

        def to_info
          @raw
        end

      end # class TestCase
    end # class Service
  end # class Resource
end # module Webspicy
