module Webspicy
  class Client

    def initialize(scope)
      @scope = scope
    end
    attr_reader :scope

    def config
      scope.config
    end

    def before(*args, &bl)
      config.before_listeners.each do |beach|
        args << self
        beach.call(*args, &bl)
      end
    end

  end
end
