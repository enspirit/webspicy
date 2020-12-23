module Webspicy
  class Specification
    include Support::DataObject

    def initialize(raw, location = nil)
      super(raw)
      @location = location
      bind_services
    end
    attr_accessor :config
    attr_reader :location

    def self.info(raw)
      new(raw)
    end

    def self.singleservice(raw)
      converted = {
        name: raw[:name] || "Unamed specification",
        url: raw[:url],
        services: [
          Webspicy.service(raw.reject{|k| k==:url or k==:name }, Webspicy.current_scope)
        ]
      }
      info(converted)
    end

    def located_at!(location)
      @location = Path(location)
    end

    def locate(relative_path)
      file = @location.parent/relative_path
      raise "File not found: #{file}" unless file.exists?
      file
    end

    def name
      @raw[:name]
    end

    def url
      @raw[:url]
    end

    def url_pattern
      @url_pattern ||= Mustermann.new(url, type: :template)
    end

    def services
      @raw[:services] || []
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

    def bind_services
      services.each do |s|
        s.specification = self
      end
    end

  end # class Specification
end # module Webspicy
require_relative 'specification/service'
require_relative 'specification/condition'
require_relative 'specification/precondition'
require_relative 'specification/postcondition'
require_relative 'specification/test_case'
require_relative 'specification/file_upload'
