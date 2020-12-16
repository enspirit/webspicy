module Webspicy
  class Tester
    class Client

      def initialize(scope)
        @scope = scope
      end
      attr_reader :scope

      def config
        scope.config
      end

      def around(*args, &bl)
        args << self
        ls = config.listeners(:around_each)
        if ls.size == 0
          bl.call
        elsif ls.size > 1
          _around(ls.first, ls[1..-1], args, &bl)
        else
          ls.first.call(*args, &bl)
        end
      end

      def _around(head, tail, args, &bl)
        head.call(*args) do
          if tail.empty?
            bl.call
          else
            _around(tail.first, tail[1..-1], args, &bl)
          end
        end
      end
      private :_around

      def instrument(*args, &bl)
        args << self
        config.listeners(:instrument).each do |i|
          i.call(*args, &bl)
        end
      end

      def before(*args, &bl)
        args << self
        config.listeners(:before_each).each do |beach|
          beach.call(*args, &bl)
        end
      end

      def after(*args, &bl)
        args << self
        config.listeners(:after_each).each do |aeach|
          aeach.call(*args, &bl)
        end
      end

    end # class Client
  end # class Tester
end # module Webspicy
require_relative 'client/support'
require_relative 'client/http_client'
require_relative 'client/rack_test_client'
