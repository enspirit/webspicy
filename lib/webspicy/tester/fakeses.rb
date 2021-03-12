require 'base64'

module Webspicy
  class Tester
    class Fakeses
      include Webspicy::Support::World::Item

      DEFAULT_OPTIONS = {
        endpoint: "http://fake-ses/_/api"
      }

      def initialize(options = {})
        @options = DEFAULT_OPTIONS.merge(options)
      end
      attr_reader :options

      def endpoint
        options[:endpoint]
      end

      def clear!
        res = HTTP.post("#{endpoint}/reset")
      end

      def emails
        res = HTTP.get("#{endpoint}/emails")
        JSON.parse(res.body).map{|data| Email.new(data) }
      end

      def emails_count
        emails.length
      end

      def last_email
        emails.last
      end

    end # class Fakeses
  end # class Tester
end # module Websipcy
require_relative 'fakeses/email'
