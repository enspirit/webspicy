module Webspicy
  class Specification
    module Condition
      extend Forwardable

      MATCH_ALL = "__all__"

      attr_accessor :matching_description

      # Given a service and a condition, returns a Pre instance of there is a
      # match, nil otherwise.
      def self.match(service, condition)
      end

      # Bind the condition instance to a current tester.
      def bind(tester)
        @tester = tester
        self
      end
      attr_reader :tester

      def_delegators :@tester, *[
        :config, :scope, :client,
        :specification, :spec_file,
        :service, :test_case,
        :invocation, :result,
        :reporter
      ]

      def sooner_or_later(*args, &bl)
        Webspicy::Support.sooner_or_later(*args, &bl)
      end

      def fail!(msg)
        raise Tester::Failure, msg
      end

      def to_s
        if matching_description == MATCH_ALL
          self.class.name
        else
          matching_description
        end
      end

    end # module Condition
  end # class Specification
end # module Webspicy
