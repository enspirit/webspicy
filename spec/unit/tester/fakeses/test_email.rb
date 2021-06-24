require 'spec_helper'
require 'webspicy/tester/fakeses'
module Webspicy
  class Tester
    class Fakeses
      describe Email do

        DATA = Base64.encode64 <<~J
        Content-Type: multipart/alternative;
        boundary="--_NmP-d246fd025a6652c9-Part_1"
        From: Webspicy <noreply@webspicy.io>
        To: david.parloir@gmail.com
        Subject: Hey world, hello!
        Message-ID: <2421bae3-9c42-7988-23b4-b1f6168130c9@webspicy.io>
        Date: Thu, 24 Jun 2021 13:45:16 +0000
        MIME-Version: 1.0

        ----_NmP-d246fd025a6652c9-Part_1
        Content-Type: text/plain; charset=utf-8
        Content-Transfer-Encoding: 7bit

        Hello world, in a text version
        ----_NmP-d246fd025a6652c9-Part_1
        Content-Type: text/html; charset=utf-8
        Content-Transfer-Encoding: 7bit

        Hello world, in an html version
        ----_NmP-d246fd025a6652c9-Part_1--
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
          expect(subject.from).to eql("Webspicy <noreply@webspicy.io>")
          expect(subject.to).to eql(["someone@world.com"])
          expect(subject.subject).to eql("Hey world, hello!")
        end

      end
    end
  end
end
