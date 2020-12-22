module Webspicy
  class Checker

    def self.new(*args, &bl)
      require_relative 'rspec/checker'
      RSpecChecker.new(*args, &bl)
    end

  end # class Checker
end # module Webspicy
