module Webspicy
  module Web
    class Specification
      class TestCase < Webspicy::Specification::TestCase

        def self.v2(info)
          info = info.dup
          if !info.has_key?(:description) && (info.has_key?(:when) || info.has_key?(:it))
            info[:description] = "when #{info[:when]}" if info.has_key?(:when)
            info[:description] << ", it #{info[:it]}" if info.has_key?(:it)
            info.delete_if{|k,v| k == :when || k == :it }
          end
          if !info.has_key?(:dress_params) && info.has_key?(:validate_input)
            info[:dress_params] = info[:validate_input]
            info.delete(:validate_input)
          end
          if !info.has_key?(:params) && info.has_key?(:input)
            info[:params] = info[:input]
            info.delete(:input)
          end
          new(info)
        end

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

        def to_v2
          info = to_info
          info = info.merge({
            validate_input: !!info[:dress_params],
            input: info[:params] || {},
          }).delete_if{|k,v| k == :dress_params || k == :params }
          if info[:description] =~ /^when (.*?), it (.*)$/
            info[:when] = $1
            info[:it] = $2
            info.delete(:description)
          end
          info
        end

      end # class TestCase
    end # class Specification
  end # module Web
end # module Webspicy
