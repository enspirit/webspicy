module Webspicy
  class Tester
    class Fakesendgrid
      class Email

        def initialize(data)
          @data = data
        end
        attr_reader :data

        def from
          @from ||= data["from"]["email"]
        end

        def to
          @to ||= data["personalizations"]
            .select{|h| h.key? "to" }
            .map{|(h)| h["to"] }
            .map{|(h)| h["email"] }
        end

        def subject
          @subject ||= data["subject"]
        end

      end # class Email
    end # class Fakesendgrid
  end # class Tester
end # module Webspicy
