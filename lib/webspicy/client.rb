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
      config.listeners(:before_each).each do |beach|
        args << self
        beach.call(*args, &bl)
      end
    end

    def after(*args, &bl)
      config.listeners(:after_each).each do |aeach|
        args << self
        aeach.call(*args, &bl)
      end
    end

  end
end
