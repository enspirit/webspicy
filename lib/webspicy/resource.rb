module Webspicy
  class Resource

    def initialize(raw)
      @raw = raw
      bind_services
    end

    def self.info(raw)
      new(raw)
    end

    def url
      @raw[:url]
    end

    def services
      @raw[:services]
    end

    def url_placeholders
      url.scan(/\{([a-zA-Z]+)\}/).map{|x| x.first.to_sym }
    end

    def instantiate_url(params)
      url, rest = self.url, params.dup
      url_placeholders.each do |placeholder|
        if (params.has_key?(placeholder))
          url = url.gsub("{#{placeholder}}", params[placeholder].to_s)
          rest.delete(placeholder)
        else
          raise "Missing URL parameter `#{placeholder}`\n\t(#{params.inspect})"
        end
      end
      [ url, rest ]
    end

    def to_info
      @raw
    end

  private

    def bind_services
      (@raw[:services] ||= []).each do |s|
        s.resource = self
      end
    end

  end
end
require_relative 'resource/service'
