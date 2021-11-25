module Webspicy
  class Tester
    class Fakesmtp
      class Email

        def initialize(data)
          @data = data
        end
        attr_reader :data

        def from
          @from ||= data["headerLines"]
            .select{|h| h["key"] == "from" }
            .map{|h| h["line"][/From:\s*(.*)$/, 1] }
            .first
        end

        def to
          @to ||= data["to"]["value"]
            .map{|h| h["address"] }
        end

        def cc
          @cc ||= data["cc"]["value"]
            .map{|h| h["address"] }
        end

        def reply_to
          @reply_to ||= data["headerLines"]
            .select{|h| h["key"] == "reply-to" }
            .map{|h| h["line"][/Reply-To:\s*(.*)$/, 1] }
        end

        def subject
          @subject ||= data["subject"] || data["headerLines"]
              .select{|h| h["key"] == "subject" }
              .map{|h| h["line"][/Subject:\s*(.*)$/, 1] }
              .first
        end

        def headers
          @headers ||= data["headerLines"]
            .reduce(OpenStruct.new){|acc, h|
              acc[h["key"].downcase] = h["line"].split(': ')[1..].join(': ')
              acc
            }
        end

      end # class Email
    end # class Fakesmtp
  end # class Tester
end # module Webspicy
