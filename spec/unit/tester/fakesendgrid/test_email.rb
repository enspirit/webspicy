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
            "email": "info@mydomain.be",
            "name": "Foo Bar"
          },
          "subject": "Hello World",
          "personalizations": [
            {
              "to": [
                {
                  "email": "support@mydomain.fr"
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
          expect(subject.from).to eql("Foo Bar <info@mydomain.be>")
          expect(subject.to).to eql(["support@mydomain.fr"])
          expect(subject.subject).to eql("Hello World")
        end

      end
    end
  end
end
