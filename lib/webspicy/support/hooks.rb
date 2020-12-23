module Webspicy
  module Support
    module Hooks

      def fire_around(*args, &bl)
        ls = config.listeners(:around_each)
        if ls.size == 0
          bl.call
        elsif ls.size > 1
          _fire_around(ls.first, ls[1..-1], args, &bl)
        else
          ls.first.call(*args, &bl)
        end
      end

      def _fire_around(head, tail, args, &bl)
        head.call(*args) do
          if tail.empty?
            bl.call
          else
            _fire_around(tail.first, tail[1..-1], args, &bl)
          end
        end
      end
      private :_fire_around

      def fire_before_each(*args, &bl)
        config.listeners(:before_each).each do |beach|
          beach.call(*args, &bl)
        end
      end

      def fire_after_each(*args, &bl)
        config.listeners(:after_each).each do |aeach|
          aeach.call(*args, &bl)
        end
      end

      def fire_instrument(*args, &bl)
        config.listeners(:instrument).each do |i|
          i.call(*args, &bl)
        end
      end

    end # module Hooks
  end # module Support
end # module Webspicy