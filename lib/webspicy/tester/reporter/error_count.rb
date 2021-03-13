module Webspicy
  class Tester
    class Reporter
      class ErrorCount < Reporter

        def initialize(*args, &bl)
          super
          @errors = Hash.new{|h,k| 0 }
        end
        attr_reader :errors

        [
          :spec_file_error,
          :check_error,
          :check_failure
        ].each do |meth|
          define_method(meth) do |*args, &bl|
            @errors[meth] += 1
          end
        end

        def report
          @errors.values.inject(0){|memo,x| memo+x }
        end

      end # class ErrorCount
    end # class Reporter
  end # class Tester
end # module Webspicy
