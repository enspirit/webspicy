module Webspicy
  class Client

    def initialize(scope)
      @scope = scope
    end
    attr_reader :scope

    def config
      scope.config
    end

  end
end
