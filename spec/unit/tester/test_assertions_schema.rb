require 'spec_helper'

module Webspicy
  class Tester
    describe "Assertions schema" do

      data = YAML.load <<~Y
      ---
      response:
          headers:
              Content-Type: application/json
      output:
      - equals('hobby', 'sports')
      - id: 1
      - name: /hello/
      Y

      it 'passes' do
        expect {
          FORMALDOC['Assertions'].dress(data)
        }.not_to raise_error
      end
    end
    describe "Regexp schema" do
      it 'works' do
        got = FORMALDOC['Regexp'].dress("/abc/")
        expect(got).to be_a(Regexp)
        expect(got).to eql(/abc/)
        expect(got).to match("hello abcdef")
      end
    end
  end
end
