module Webspicy
  class Tester
    class Fakeses
      class Email

        def initialize(data)
          @data = data
        end
        attr_reader :data

        def from
          data["body"]["Source"]
        end

        def to
          data["body"]
            .each_pair
            .select{|(k,v)|
              k =~ /Destinations.member/
            }
            .map{|(k,v)| v }
        end

        def subject
          rx = /^Subject:\s*(.*)$/
          raw_data
            .each_line
            .find{|l| l =~ rx }[rx, 1]
        end

        def raw_data
          @raw_data ||= Base64.decode64(data["body"]["RawMessage.Data"])
        end

      end # class Email
    end # class Fakeses
  end # class Tester
end # module Webspicy
