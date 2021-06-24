module Webspicy
  class Tester
    class Fakeses
      class Email

        def initialize(data)
          @data = data
        end
        attr_reader :data

        def from
          rx = /^From:\s*(.*)$/
          raw_data
            .each_line
            .find{|l| l =~ rx }[rx, 1].strip
        end

        def to
          data["body"]
            .each_pair
            .select{|(k,v)|
              k =~ /Destinations.member/
            }
            .map{|(k,v)| v.strip }
        end

        def subject
          rx = /^Subject:\s*(.*)$/
          raw_data
            .each_line
            .find{|l| l =~ rx }[rx, 1].strip
        end

        def raw_data
          @raw_data ||= Base64.decode64(data["body"]["RawMessage.Data"])
        end

      end # class Email
    end # class Fakeses
  end # class Tester
end # module Webspicy
