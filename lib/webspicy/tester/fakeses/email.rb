require 'mail'

module Webspicy
  class Tester
    class Fakeses
      class Email

        def initialize(data)
          @data = data
        end
        attr_reader :data

        def from
          email.from[0]
        end

        def recipients
          data["body"]
            .each_pair
            .select{|(k,v)|
              k =~ /Destinations.member/
            }
            .map{|(k,v)| v.strip }
        end

        def to
          email.to
        end

        def subject
          email.subject
        end

        def cc
          email.cc
        end

        def bcc
          recipients - cc - to
        end

        def email
          @email ||= Mail.read_from_string(raw_data)
        end

        def raw_data
          @raw_data ||= Base64.decode64(data["body"]["RawMessage.Data"])
        end

      end # class Email
    end # class Fakeses
  end # class Tester
end # module Webspicy
