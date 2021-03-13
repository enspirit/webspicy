module Webspicy
  class Tester
    class Reporter
      class Documentation < Reporter

        module Helpers
          def spec_file_error_line(spec_file, ex)
            str = colorize_highlight(spec_file.to_s, config)
            str += "\n  " + colorize_error("X  #{ex.message}", config)
            if ex.root_cause && ex.root_cause != ex
              str += "\n    " + colorize_error("#{ex.root_cause.message}", config)
            end
            str
          end

          def service_line(service, test_case)
            str = service.to_s + ", " + test_case.to_s
            str = colorize_highlight(str, config)
          end

          def check_success_line(check)
            "  " + colorize_success("v  " + check.behavior, config)
          end

          def check_failure_line(check, ex)
            "  " + colorize_error("F  " + ex.message, config)
          end

          def check_error_line(check, ex)
            "  " + colorize_error("E  " + ex.message, config)
          end
        end
        include Helpers

        def spec_file_error(e)
          io.puts spec_file_error_line(spec_file, e)
          io.puts
          io.flush
        end

        def before_test_case
          io.puts service_line(service, test_case)
          io.flush
        end

        def check_success(check)
          io.puts check_success_line(check)
          io.flush
        end

        def check_failure(check, ex)
          io.puts check_failure_line(check, ex)
          io.flush
        end

        def check_error(check, ex)
          io.puts check_error_line(check, ex)
          io.flush
        end

        def test_case_done
          io.puts
          io.flush
        end

        def service_done
          io.puts
          io.flush
        end

      end # class Documentation
    end # class Reporter
  end # class Tester
end # module Webspicy
