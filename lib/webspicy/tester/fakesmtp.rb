module Webspicy
  class Tester
    class Fakesmtp
      include Webspicy::Support::World::Item

      DEFAULT_OPTIONS = {
        endpoint: "http://fakesmtp"
      }

      def initialize(options = {})
        @options = DEFAULT_OPTIONS.merge(options)
      end
      attr_reader :options

      def endpoint
        options[:endpoint]
      end

      def clear!
        res = HTTP.delete("#{endpoint}/emails")
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

    end # class Fakesmtp
  end # class Tester
end # module Webspicy
require_relative 'fakesmtp/email'
