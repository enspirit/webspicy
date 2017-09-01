module Webspicy
  class Resource
    class Service
      class TestCase

        def initialize(raw)
          @raw = raw
        end
        attr_accessor :service

        def resource
          service.resource
        end

        def self.info(raw)
          new(raw)
        end

        def description
          @raw[:description]
        end

        def seeds
          @raw[:seeds]
        end

        def headers
          @raw[:headers] ||= {}
        end

        def dress_params
          @raw.fetch(:dress_params){ true }
        end
        alias :dress_params? :dress_params

        def params
          @raw[:params]
        end

        def body
          @raw[:body]
        end

        def expected_content_type
          @raw[:expected].fetch(:content_type){ 'application/json' }
        end

        def expected_status
          @raw[:expected][:status]
        end

        def expected_error
          @raw[:expected][:error]
        end

        def has_expected_error?
          !expected_error.nil?
        end

        def expected_headers
          @raw[:expected][:headers] || {}
        end

        def has_expected_headers?
          !expected_headers.empty?
        end

        def assert
          @raw[:assert] || []
        end

        def has_assertions?
          !assert.empty?
        end

        def to_info
          @raw
        end

        def instrument
          service.preconditions.each do |pre|
            pre.instrument(self)
          end
        end

        def to_s
          description
        end

      end # class TestCase
    end # class Service
  end # class Resource
end # module Webspicy
