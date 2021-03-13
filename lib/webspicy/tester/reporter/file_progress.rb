module Webspicy
  class Tester
    class Reporter
      class FileProgress < Reporter

        def spec_file_error(e)
          io.print colorize_error("X", config)
          io.flush
        end

        def spec_file_done
          io.print colorize_success(".", config)
          io.flush
        end

        def report
          io.puts
          io.puts
          io.flush
        end

      end # class FileProgress
    end # class Reporter
  end # class Tester
end # module Webspicy
