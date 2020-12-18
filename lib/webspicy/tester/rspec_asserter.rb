module Webspicy
  class Tester
    class RSpecAsserter

      def initialize(rspec, invocation)
        @rspec = rspec
        @invocation = invocation
      end
      attr_reader :rspec,  :invocation

      def response
        invocation.response
      end

      def test_case
        invocation.test_case
      end

      def service
        test_case.service
      end

      def assert!
        assert_status_met
        assert_content_type_met
        assert_expected_headers
        assert_output_schema_met
        assert_assertions_met
        assert_postconditions_met

        assert_no_other_errors
      end

      def assert_status_met
        got = response.status
        expected = test_case.expected_status
        rspec.expect(got).to rspec.match_response_status(expected)
      end

      def assert_content_type_met
        return if test_case.is_expected_status?(204)
        return unless ect = test_case.expected_content_type
        got = response.content_type
        got = got.mime_type if got.respond_to?(:mime_type)
        if ect.nil?
          rspec.expect(ect).to rspec.have_no_response_type
        else
          rspec.expect(got).to rspec.match_content_type(ect)
        end
      end

      def assert_expected_headers
        return unless test_case.has_expected_headers?
        test_case.expected_headers.each_pair do |k,v|
          got = response.headers[k]
          if got.nil?
            rspec.expect(got).to rspec.be_in_response_headers(k)
          else
            rspec.expect(got).to rspec.match_response_header(k, v)
          end
        end
      end

      def assert_output_schema_met
        return if test_case.is_expected_status?(204)
        return if invocation.is_redirect?
        if invocation.is_empty_response?
          body = response.body.to_s.strip
          rspec.expect(body).to rspec.be_an_empty_response_body
        else
          b = invocation.dressed_body
          if invocation.is_expected_success?
            rspec.expect(b).to rspec.meet_output_schema
          else
            rspec.expect(b).to rspec.meet_error_schema
          end
        end
      end

      def assert_assertions_met
        return unless test_case.has_assertions?
        asserter = Tester::Asserter.new(invocation.dressed_body)
        test_case.assert.each do |assert|
          begin
            asserter.instance_eval(assert)
          rescue => ex
            rspec.expect(ex).to rspec.meet_assertion(assert)
          end
        end
      end

      def assert_postconditions_met
        return unless service.has_postconditions?
        return if test_case.counterexample?
        service.postconditions.each do |post|
          msg = post.check(invocation)
          rspec.expect(msg).to rspec.meet_postcondition(post)
        end
      end

      def assert_no_other_errors
        errors = invocation.errors
        rspec.expect(errors).to rspec.be_an_empty_errors_array
      end

    end # class RSpecAsserter
  end # class Tester
end # module Webspicy
