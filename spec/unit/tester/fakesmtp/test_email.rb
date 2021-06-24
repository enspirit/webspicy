require 'spec_helper'
require 'webspicy/tester/fakesmtp'
module Webspicy
  class Tester
    class Fakesmtp
      describe Email do

        DATA = JSON.parse <<~J
        {
          "attachments": [],
          "headerLines": [
            {
              "key": "date",
              "line": "Date: Tue, 20 Apr 2021 14:06:13 +0000"
            },
            {
              "key": "from",
              "line": "From: Webspicy <noreply@webspicy.io>"
            },
            {
              "key": "reply-to",
              "line": "Reply-To: test@email.be"
            },
            {
              "key": "to",
              "line": "To: support@mydomain.fr"
            },
            {
              "key": "message-id",
              "line": "Message-ID: <607edfd56836e_1b0492af@1d3356d02030.mail>"
            },
            {
              "key": "subject",
              "line": "Subject: Hello World"
            },
            {
              "key": "mime-version",
              "line": "Mime-Version: 1.0"
            }
          ],
          "html": "<p>Hello World!!</p>",
          "text": "Hello World!!",
          "textAsHtml": "Hello World!!",
          "subject": "Hello World",
          "date": "2021-04-20T14:06:13.000Z",
          "to": {
            "value": [
              {
                "address": "support@mydomain.fr",
                "name": ""
              }
            ],
            "html": "<span class=\\"mp_address_group\\"><a href=\\"mailto:support@mydomain.fr\\" class=\\"mp_address_email\\">support@mydomain.fr</a></span>",
            "text": "support@mydomain.fr"
          },
          "from": {
            "value": [
              {
                "address": "info@mydomain.be",
                "name": ""
              }
            ],
            "html": "<span class=\\"mp_address_group\\"><a href=\\"mailto:info@mydomain.be\\" class=\\"mp_address_email\\">info@mydomain.be</a></span>",
            "text": "info@mydomain.be"
          },
          "messageId": "<607edfd56836e_1b0492af@1d3356d02030.mail>",
          "replyTo": {
            "value": [
              {
                "address": "test@email.be",
                "name": ""
              }
            ],
            "html": "<span class=\\"mp_address_group\\"><a href=\\"mailto:test@email.be\\" class=\\"mp_address_email\\">test@email.be</a></span>",
            "text": "test@email.be"
          }
        }
        J

        subject{
          Email.new(DATA)
        }

        it 'works as expected' do
          expect(subject.from).to eql("Webspicy <noreply@webspicy.io>")
          expect(subject.to).to eql(["support@mydomain.fr"])
          expect(subject.subject).to eql("Hello World")
        end

      end
    end
  end
end
