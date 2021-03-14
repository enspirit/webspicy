module Webspicy
  module Web
    class Specification
      class TestCase < Webspicy::Specification::TestCase

        def headers
          @raw[:headers] ||= {}
        end

        def dress_params
          @raw.fetch(:dress_params){ true }
        end
        alias :dress_params? :dress_params

        def params
          @raw[:params] || {}
        end

        def body
          @raw[:body]
        end

        def file_upload
          @raw[:file_upload]
        end

        def located_file_upload
          file_upload ? file_upload.locate(specification) : nil
        end

        def expected_content_type
          expected[:content_type]
        end

        def expected_status
          expected[:status]
        end

        def is_expected_status?(status)
          expected_status === status
        end

        def has_expected_status?
          not expected[:status].nil?
        end

        def expected_headers
          expected[:headers] || {}
        end

        def has_expected_headers?
          !expected_headers.empty?
        end

      end # class TestCase
    end # class Specification
  end # module Web
end # module Webspicy
