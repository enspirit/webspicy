module Webspicy
  class Tester
    class Reporter
      class Documentation < Reporter

        module Helpers
          INDENT = "  ".freeze

          def spec_file_line(spec_file)
            path = Path(spec_file).expand_path
            path = path.relative_to(config.folder)
            path = spec_file if path.to_s.start_with?(".")
            colorize_section(">> #{path}", config)
          end

          def spec_file_error_line(spec_file, ex)
            str = ""
            str += colorize_error(INDENT + "X  #{ex.message}", config)
            if ex.root_cause && ex.root_cause != ex
              str += "\n"
              str += INDENT + colorize_error("#{ex.root_cause.message}", config)
            end
            str
          end

          def service_line(service, test_case)
            str = "#{service}, #{test_case}"
            str = colorize_highlight(str, config)
          end

          def check_success_line(check)
            INDENT + colorize_success("v  " + check.behavior, config)
          end

          def check_failure_line(check, ex)
            INDENT + colorize_error("F  " + ex.message, config)
          end

          def check_error_line(check, ex)
            INDENT + colorize_error("E  " + ex.message, config)
          end
        end
        include Helpers

        def spec_file_error(e)
          io.puts spec_file_line(spec_file)
          io.puts
          io.puts spec_file_error_line(spec_file, e)
          io.puts
          io.flush
        end

        def before_service
          @spec_file_line_printed = false
        end

        def before_test_case
          unless @spec_file_line_printed
            io.puts spec_file_line(spec_file)
            io.puts
            io.flush
            @spec_file_line_printed = true
          end
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
