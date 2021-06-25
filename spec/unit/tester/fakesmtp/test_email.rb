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
              "line": "Reply-To: noreply@webspicy.io"
            },
            {
              "key": "to",
              "line": "To: someone@world.com, someoneelse@world.com"
            },
            {
              "key": "cc",
              "line": "Cc: a-cc-recipient@world.com"
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
                "address": "someone@world.com",
                "name": ""
              },
              {
                "address": "someoneelse@world.com",
                "name": ""
              }
            ]
          },
          "from": {
            "value": [
              {
                "address": "info@mydomain.be",
                "name": ""
              }
            ]
          },
          "messageId": "<607edfd56836e_1b0492af@1d3356d02030.mail>",
          "replyTo": {
            "value": [
              {
                "address": "noreply@webspicy.io",
                "name": ""
              }
            ]
          },
          "cc": {
            "value": [
              {
                "address": "a-cc-recipient@world.com",
                "name": ""
              }
            ]
          }
        }
        J

        subject{
          Email.new(DATA)
        }

        it 'works as expected' do
          expect(subject.from).to eql("Webspicy <noreply@webspicy.io>")
          expect(subject.to).to eql(["someone@world.com", "someoneelse@world.com"])
          expect(subject.cc).to eql(["a-cc-recipient@world.com"])
          expect(subject.subject).to eql("Hello World")
        end

      end
    end
  end
end
