module Webspicy
  class Resource
    class Service
      class Invocation

        def initialize(service, test_case, response, client)
          @service = service
          @test_case = test_case
          @response = response
          @client = client
        end

        attr_reader :service, :test_case, :response, :client

        def errors
          @errors ||= begin
            errs = [
              [:expected_status_unmet, true],
              [:expected_content_type_unmet, !test_case.is_expected_status?(204)],
              [:expected_headers_unmet, test_case.has_expected_headers?],
              [:expected_schema_unmet, !test_case.is_expected_status?(204)],
              [:assertions_unmet, test_case.has_assertions?],
              [:postconditions_unmet, test_case.service.has_postconditions? && !test_case.counterexample?],
              [:expected_error_unmet, test_case.has_expected_error?]
            ].map do |(expectation,only_if)|
              next unless only_if
              begin
                self.send(expectation)
              rescue => ex
                ex.message
              end
            end
            errs.compact
          end
        end

        def has_error?
          !errors.empty?
        end

        ### Getters on response

        def response_code
          code = response.status
          code = code.code unless code.is_a?(Integer)
          code
        end

        ### Query methods

        def done?
          !response.nil?
        end

        def is_expected_success?
          test_case.expected_status.to_i >= 200 && test_case.expected_status.to_i < 300
        end

        def is_success?
          response_code >= 200 && response_code < 300
        end

        def is_empty_response?
          response_code == 204
        end

        def is_redirect?
          response_code >= 300 && response_code < 400
        end

        ### Check of HTTP status

        def expected_status_unmet
          expected = test_case.expected_status
          got = response.status
          expected === got ? nil : "#{expected} != #{got}"
        end

        def meets_expected_status?
          expected_status_unmet.nil?
        end

        ### Check of the expected output type

        def expected_content_type_unmet
          ect = test_case.expected_content_type
          got = response.content_type
          got = got.mime_type if got.respond_to?(:mime_type)
          if ect.nil?
            got.nil? ? nil : "#{ect} != #{got}"
          else
            got.to_s.start_with?(ect.to_s) ? nil : "#{ect} != #{got}"
          end
        end

        def meets_expected_content_type?
          expected_content_type_unmet.nil?
        end

        ### Check of output schema

        def expected_schema_unmet
          if is_empty_response?
            body = response.body.to_s.strip
            body.empty? ? nil : "Expected empty body, got #{body}"
          elsif is_redirect?
          else
            case dressed_body
            when Finitio::TypeError
              rc = dressed_body.root_cause
              "#{rc.message} (#{rc.location ? rc.location : 'unknown location'})"
            when StandardError
              dressed_body.message
            else nil
            end
          end
        end

        def meets_expected_schema?
          expected_schema_unmet.nil?
        end

        ### Check of assertions

        def assertions_unmet
          unmet = []
          asserter = Tester::Asserter.new(dressed_body)
          test_case.assert.each do |assert|
            begin
              asserter.instance_eval(assert)
            rescue => ex
              unmet << ex.message
            end
          end
          unmet.empty? ? nil : unmet.join("\n")
        end

        def value_equal(exp, got)
          case exp
          when Hash
            exp.all?{|(k,v)|
              got[k] == v
            }
          else
            exp == got
          end
        end

        ### Check of expected error message

        def expected_error_unmet
          expected = test_case.expected_error
          case test_case.expected_content_type
          when %r{json}
            got = meets_expected_schema? ? dressed_body[:description] : response.body
            expected == got ? nil : "`#{expected}` vs. `#{got}`"
          else
            dressed_body.include?(expected) ? nil : "#{expected} not found" unless expected.nil?
          end
        end

        ### Check of expected headers

        def expected_headers_unmet
          unmet = []
          expected = test_case.expected_headers
          expected.each_pair do |k,v|
            got = response.headers[k]
            unmet << "#{v} expected for #{k}, got #{got}" unless (got == v)
          end
          unmet.empty? ? nil : unmet.join("\n")
        end

        ### Check of postconditions

        def postconditions_unmet
          failures = service.postconditions.map{|post|
            post.check(self)
          }.compact
          failures.empty? ? nil : failures.join("\n")
        end

      private

        def loaded_body
          case test_case.expected_content_type
          when %r{json}
            raise "Body empty while expected" if response.body.to_s.empty?
            @loaded_body ||= ::JSON.parse(response.body)
          else
            response.body.to_s
          end
        end

        def dressed_body
          @dressed_body ||= case test_case.expected_content_type
          when %r{json}
            schema = is_expected_success? ? service.output_schema : service.error_schema
            begin
              schema.dress(loaded_body)
            rescue Finitio::TypeError => ex
              ex
            end
          else
            loaded_body
          end
        end

      end # class Invocation
    end # class Service
  end # class Resource
end # module Webspicy
