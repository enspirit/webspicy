require 'spec_helper'
module Webspicy
  module Web
    class Specification
      describe TestCase, "v2 information contract" do

        it 'dresses fine' do
          tc = Webspicy::Web.test_case({
            when: "a condition",
            it: "does something",
            input: { foo: "bar" },
            validate_input: false,
          })
          expect(tc.description).to eql("when a condition, it does something")
          expect(tc.params).to eql({ foo: "bar" })
          expect(tc.dress_params).to eql(false)
        end

        it 'undresses fine' do
          tc = Webspicy::Web.test_case({
            when: "a condition",
            it: "does something",
            input: { foo: "bar" },
            validate_input: false,
          })
          expect(tc.to_v2).to eql({
            when: "a condition",
            it: "does something",
            input: { foo: "bar" },
            validate_input: false,
          })
        end

        it 'keeps to_info clean' do
          tc = Webspicy::Web.test_case({
            when: "a condition",
            it: "does something",
            input: { foo: "bar" },
            validate_input: false,
          })
          expect(tc.to_info).to eql({
            description: "when a condition, it does something",
            params: { foo: "bar" },
            dress_params: false,
          })
        end
      end
    end
  end
end
