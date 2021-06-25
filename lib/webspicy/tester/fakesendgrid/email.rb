module Webspicy
  class Tester
    class Fakesendgrid
      class Email

        def initialize(data)
          @data = data
        end
        attr_reader :data

        def from
          @from ||= data['from']['name'] ?
            "#{data['from']['name']} <#{data['from']['email']}>" :
            data['from']['email']
        end

        def to
          @to ||= data["personalizations"]
            .select{|h| h.key? "to" }
            .map{|(h)| h["to"] }
            .flatten
            .map{|(h)| h["email"] }
        end

        def cc
          @cc ||= data["personalizations"]
            .select{|h| h.key? "cc" }
            .map{|(h)| h["cc"] }
            .flatten
            .map{|(h)| h["email"] }
        end

        def bcc
          @bcc ||= data["personalizations"]
            .select{|h| h.key? "bcc" }
            .map{|(h)| h["bcc"] }
            .flatten
            .map{|(h)| h["email"] }
        end

        def subject
          @subject ||= data["subject"]
        end

      end # class Email
    end # class Fakesendgrid
  end # class Tester
end # module Webspicy
