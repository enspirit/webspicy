module Webspicy
  class Tester

    def self.new(*args, &bl)
      require_relative 'rspec/tester'
      RSpecTester.new(*args, &bl)
    end

  end # class Tester
end # module Webspicy
require_relative 'tester/reporter'
require_relative 'tester/base'
require_relative 'tester/client'
require_relative 'tester/invocation'
require_relative 'tester/result'
require_relative 'tester/failure'
require_relative 'tester/assertions'
require_relative 'tester/asserter'
