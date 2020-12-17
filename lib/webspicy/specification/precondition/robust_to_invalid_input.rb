module Webspicy
  class Specification
    module Precondition
      class RobustToInvalidInput
        include Precondition

        def self.match(service, pre)
          self.new
        end

        def match(service, pre)
          self
        end

        def counterexamples(service)
          spec = service.specification
          first = service.examples.first
          cexamples = []
          cexamples += url_randomness_counterexamples(service, first) if first
          cexamples += empty_input_counterexamples(service, first) if first
          cexamples
        end

      protected

        def url_randomness_counterexamples(service, first)
          service.specification.url_placeholders.map{|p|
            first.mutate({
              :description => "it is robust to URL randomness on param `#{p}` (RobustToInvalidInput)",
              :dress_params => false,
              :params => first.params.merge(p => (SecureRandom.random_number * 100000000).to_i),
              :expected => {
                status: Support::StatusRange.str("4xx")
              },
              :assert => []
            })
          }
        end

        def empty_input_counterexamples(service, first)
          placeholders = service.specification.url_placeholders
          empty_input = first.params.reject{|k| !placeholders.include?(k) }
          if !empty_input.empty? && invalid_input?(service, empty_input)
            [first.mutate({
              :description => "it is robust to an invalid empty input (RobustToInvalidInput)",
              :dress_params => false,
              :params => empty_input,
              :expected => {
                status: Support::StatusRange.str("4xx")
              },
              :assert => []
            })]            
          else
            []
          end
        end

        def invalid_input?(service, empty_input)
          service.input_schema.dress(empty_input)
          false
        rescue Finitio::Error
          true
        end

      end # class RobustToInvalidInput
    end # module Precondition
  end # class Specification
end # module Webspicy
