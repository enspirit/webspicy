module Webspicy
  class Tester
    class Reporter
      class Progress < Reporter

        def spec_file_error(e)
          io.print colorize_error("X")
        end

        def after_each_done
          if result.success?
            io.print colorize_success(".")
          elsif result.failure?
            io.print colorize_error("F")
          elsif result.error?
            io.print colorize_error("E")
          end
        end

        def report
          io.puts
          io.puts
        end

      end # class Progress
    end # class Reporter
  end # class Tester
end # module Webspicy
