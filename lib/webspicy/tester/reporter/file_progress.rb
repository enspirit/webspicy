module Webspicy
  class Tester
    class Reporter
      class FileProgress < Reporter

        def spec_file_error(e)
          io.print colorize_error("X")
        end

        def spec_file_done
          io.print colorize_success(".")
        end

        def report
          io.puts
          io.puts
        end

      end # class FileProgress
    end # class Reporter
  end # class Tester
end # module Webspicy
