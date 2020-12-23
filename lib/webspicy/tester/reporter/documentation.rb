module Webspicy
  class Tester
    class Reporter
      class Documentation < Reporter

        module Helpers
          def spec_file_error_line(spec_file, ex)
            str = colorize_highlight(spec_file.to_s)
            str += "\n  " + colorize_error("X  #{ex.message}")
            if ex.root_cause && ex.root_cause != ex
              str += "\n    " + colorize_error("#{ex.root_cause.message}")
            end
            str
          end

          def service_line(service)
            str = service.to_s + ", " + test_case.to_s
            str = colorize_highlight(str)
          end

          def check_success_line(check)
            "  " + colorize_success("v") + "  " + check.behavior
          end

          def check_failure_line(check, ex)
            "  " + colorize_error("F  " + ex.message)
          end

          def check_error_line(check, ex)
            "  " + colorize_error("E  " + ex.message)
          end
        end
        include Helpers

        def spec_file_error(e)
          io.puts spec_file_error_line(spec_file, e)
          io.puts
        end

        def before_test_case
          io.puts service_line(service)
        end

        def check_success(check)
          io.puts check_success_line(check)
        end

        def check_failure(check, ex)
          io.puts check_failure_line(check, ex)
        end

        def check_error(check, ex)
          io.puts check_error_line(check, ex)
        end

        def test_case_done
          io.puts
        end

        def service_done
          io.puts
        end

      end # class Documentation
    end # class Reporter
  end # class Tester
end # module Webspicy
