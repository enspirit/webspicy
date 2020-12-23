module Webspicy
  module Web
    class Client < Tester::Client

      def call(test_case)
        response = _call(test_case)
        Invocation.new(test_case, response, self)
      end

    end # class Client
  end # module Web
end # module Webspicy
require_relative 'client/support'
require_relative 'client/http_client'
require_relative 'client/rack_test_client'
