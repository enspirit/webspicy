module Webspicy
  module Web
    class Specification < Webspicy::Specification

      class << self
        def info(raw)
          new(raw)
        end

        def singleservice(raw)
          converted = {
            name: raw[:name],
            url: raw[:url],
            services: [
              Webspicy::Web.service(raw.reject{|k| k==:url or k==:name }, Webspicy.current_scope)
            ]
          }
          info(converted)
        end
      end

      def url
        @raw[:url]
      end

      def url_pattern
        @url_pattern ||= Mustermann.new(url, type: :template)
      end

      def url_placeholders
        url.scan(/\{([a-zA-Z]+(\.[a-zA-Z]+)*)\}/).map{|x| x.first }
      end

      def instantiate_url(params)
        url, rest = self.url, params.dup
        url_placeholders.each do |placeholder|
          value, rest = extract_placeholder_value(rest, placeholder)
          url = url.gsub("{#{placeholder}}", value.to_s)
        end
        [ url, rest ]
      end

      def to_singleservice
        raise NotImplementedError
      end

    private

      def extract_placeholder_value(params, placeholder, split = nil)
        return extract_placeholder_value(params, placeholder, placeholder.split(".")) unless split

        key = [ split.first, split.first.to_sym ].find{|k| params.has_key?(k) }
        raise "Missing URL parameter `#{placeholder}`" unless key

        if split.size == 1
          [ params[key], params.dup.delete_if{|k| k == key } ]
        else
          value, rest = extract_placeholder_value(params[key], placeholder, split[1..-1])
          [ value, params.merge(key => rest) ]
        end
      end

    end # class Specification
  end # module Web
end # module Webspicy
require_relative 'specification/pre'
require_relative 'specification/post'
require_relative 'specification/service'
require_relative 'specification/test_case'
require_relative 'specification/file_upload'
