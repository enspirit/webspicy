module Webspicy
  class Tester
    class Reporter
      class Progress < Reporter

        def spec_file_error(e)
          io.print colorize_error("X", config)
        end

        def test_case_done
          if result.success?
            io.print colorize_success(".", config)
          elsif result.failure?
            io.print colorize_error("F", config)
          elsif result.error?
            io.print colorize_error("E", config)
          end
          io.flush
        end

        def report
          io.puts
          io.puts
          io.flush
        end

      end # class Progress
    end # class Reporter
  end # class Tester
end # module Webspicy
