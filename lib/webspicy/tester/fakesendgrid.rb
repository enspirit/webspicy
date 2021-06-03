module Webspicy
  class Tester
    class Fakesendgrid
      include Webspicy::Support::World::Item

      DEFAULT_OPTIONS = {
        endpoint: "http://fakesendgrid"
      }

      def initialize(options = {})
        @options = DEFAULT_OPTIONS.merge(options)
      end
      attr_reader :options

      def endpoint
        options[:endpoint]
      end

      def clear!
        res = HTTP.delete("#{endpoint}/api/mails")
      end

      def emails
        res = HTTP.get("#{endpoint}/api/mails")
        JSON.parse(res.body).map{|data| Email.new(data) }
      end

      def emails_count
        emails.length
      end

      def last_email
        emails.first
      end

    end # class Fakesendgrid
  end # class Tester
end # module Webspicy
require_relative 'fakesendgrid/email'
