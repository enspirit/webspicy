module Webspicy
  class Tester
    class Reporter
      class Summary < Reporter

        def initialize(*args, &bl)
          super
          clear
        end
        attr_reader :spec_files_count, :examples_count, :counterexamples_count
        attr_reader :assertions_count
        attr_reader :spec_file_errors_count, :errors_count, :failures_count

        def before_spec_file
          @spec_files_count += 1
        end

        def spec_file_error(e)
          @spec_file_errors_count += 1
        end

        def test_case_done
          if tester.test_case.counterexample?
            @counterexamples_count += 1
          else
            @examples_count += 1
          end
          @assertions_count += tester.result.assertions_count
          @errors_count += tester.result.errors_count
          @failures_count += tester.result.failures_count
        end

        def report
          msg = "#{plural('spec file', spec_files_count)}, "\
                "#{plural('example', examples_count)}, "\
                "#{plural('counterexample', counterexamples_count)}\n"\
                "#{plural('assertion', assertions_count)}, "\
                "#{plural('error', errors_count)}, "\
                "#{plural('failure', failures_count)}"
          if success?
            msg = colorize_success(msg, config)
          else
            msg = colorize_error(msg, config)
          end
          io.puts(msg)
          io.puts
          io.flush
        end

        def clear
          @spec_files_count = 0
          @examples_count = 0
          @counterexamples_count = 0
          @assertions_count = 0
          #
          @spec_file_errors_count = 0
          @errors_count = 0
          @failures_count = 0
        end

        def total_error_count
          @spec_file_errors_count + @errors_count + @failures_count
        end

        def success?
          total_error_count == 0
        end

      end # class Summary
    end # class Reporter
  end # class Tester
end # module Webspicy
