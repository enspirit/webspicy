require 'spec_helper'
require 'webspicy/tester/fakeses'
module Webspicy
  class Tester
    class Fakeses
      describe Email do

        DATA = Base64.encode64 <<~J
          From: Webspicy <noreply@webspicy.io>
          To: someone@world.com
          Subject: Hey world, hello!
        J

        DATA = JSON.parse <<~J
        {
          "id": "1782605f-da34-9c02-6a38-d7e101029cbf",
          "body": {
            "Source": "noreply@webspicy.io",
            "Destinations.member.1": "someone@world.com",
            "RawMessage.Data": "#{DATA.gsub /\n/, ''}",
            "Action": "SendRawEmail",
            "Version": "2010-12-01"
          }
        }
        J

        subject{
          Email.new(DATA)
        }

        it 'works as expected' do
          expect(subject.from).to eql("noreply@webspicy.io")
          expect(subject.to).to eql(["someone@world.com"])
          expect(subject.subject).to eql("Hey world, hello!")
        end

      end
    end
  end
end
