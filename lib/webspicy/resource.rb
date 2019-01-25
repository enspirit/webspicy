module Webspicy
  class Resource

    def initialize(raw, location = nil)
      @raw = raw
      @location = location
      bind_services
    end
    attr_reader :location

    def self.info(raw)
      new(raw)
    end

    def located_at!(location)
      @location = Path(location)
    end

    def locate(relative_path)
      file = @location.parent/relative_path
      raise "File not found: #{file}" unless file.exists?
      file
    end

    def url
      @raw[:url]
    end

    def services
      @raw[:services]
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

    def to_info
      @raw
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
      (@raw[:services] ||= []).each do |s|
        s.resource = self
      end
    end

  end
end
require_relative 'resource/service'
