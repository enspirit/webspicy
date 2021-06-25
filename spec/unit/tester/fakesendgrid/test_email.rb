require 'spec_helper'
require 'webspicy/tester/fakesendgrid'
module Webspicy
  class Tester
    class Fakesendgrid
      describe Email do

        DATA = JSON.parse <<~J
        {
          "datetime": "2021-06-02T15:29:27.161Z",
          "from": {
            "email": "noreply@webspicy.io",
            "name": "Webspicy"
          },
          "subject": "Hello World",
          "personalizations": [
            {
              "to": [
                {
                  "email": "someone@world.com"
                },
                {
                  "email": "someoneelse@world.com"
                }
              ],
              "cc": [
                {
                  "email": "a-cc-recipient@world.com"
                }
              ],
              "bcc": [
                {
                  "email": "a-bcc-recipient@world.com"
                }
              ]
            }
          ],
          "content": [
            {
              "value": "test",
              "type": "text/plain"
            },
            {
              "value": "test <b>test</b> test",
              "type": "text/html"
            }
          ]
        }
        J

        subject{
          Email.new(DATA)
        }

        it 'works as expected' do
          expect(subject.from).to eql("Webspicy <noreply@webspicy.io>")
          expect(subject.to).to eql(["someone@world.com", "someoneelse@world.com"])
          expect(subject.cc).to eql(["a-cc-recipient@world.com"])
          expect(subject.bcc).to eql(["a-bcc-recipient@world.com"])
          expect(subject.subject).to eql("Hello World")
        end

      end
    end
  end
end
