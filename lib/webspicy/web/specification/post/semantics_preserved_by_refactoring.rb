module Webspicy
  module Web
    class Specification
      module Post
        class SemanticsPreservedByRefactoring
          include ::Webspicy::Specification::Post

          MATCH = /The data output semantics is preserved by the refactoring/

          def self.match(service, descr)
            return nil unless descr =~ MATCH
            SemanticsPreservedByRefactoring.new
          end

          def instrument
          end

          def check!
            test_id = {
              description: test_case.description,
              seeds: test_case.seeds,
              url: test_case.service.specification.url,
              method: test_case.service.method,
              params: test_case.params,
              headers: test_case.headers.reject{|k| k == 'Authorization' },
              metadata: test_case.metadata,
            }
            sha1 = Digest::SHA1.hexdigest(test_id.to_json)

            record_file_path = config.folder/".morpheus/#{sha1}.key.json"
            record_file_path.parent.mkdir_p
            record_file_path.write(JSON.pretty_generate(test_id))

            response = invocation.response
            test_data = {
              status: response.status,
              headers: response.headers,
              body: JSON.parse(response.body),
            }

            case ENV['MORPHEUS'].upcase
            when 'RECORD'
              expected_file_path = config.folder/".morpheus/#{sha1}.expected.json"
              expected_file_path.write(JSON.pretty_generate(test_data))
            when 'CHECK'
              expected_file_path = config.folder/".morpheus/#{sha1}.expected.json"
              expected = expected_file_path.load

              actual_file_path = config.folder/".morpheus/#{sha1}.actual.json"
              actual_file_path.write(JSON.pretty_generate(test_data))
              actual = actual_file_path.load

              fail!("Semantics has changed.") unless values_equal?(actual, expected)
            end
          end

        private

          def values_equal?(a, b)
            Tester::Asserter.new(a).eql('', b)
          end

        end # SemanticsPreservedByRefactoring
      end # module Post
    end # module Webspicy
  end # module Web
end # class Specification
