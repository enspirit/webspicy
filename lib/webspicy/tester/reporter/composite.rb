module Webspicy
  class Tester
    class Reporter
      class Composite < Reporter

        def initialize(*args, &bl)
          super
          @reporters = []
        end

        def <<(reporter)
          @reporters << reporter
          self
        end

        def init(tester)
          super
          @reporters.each do |r|
            r.init(tester)
          end
        end

        HOOKS.each do |meth|
          define_method(meth) do |*args, &bl|
            @reporters.each do |r|
              r.send(meth, *args, &bl)
            end
          end
        end

      end # class Composite
    end # class Reporter
  end # class Tester
end # module Webspicy
