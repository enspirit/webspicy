module Webspicy
  class Tester
    class Reporter
      class Summary < Reporter

        def initialize(*args, &bl)
          super
          @spec_files_count = 0
          @examples_count = 0
          @counterexamples_count = 0
          @assertions_count = 0
          @errors_count = 0
          @failures_count = 0
        end
        attr_reader :spec_files_count, :examples_count, :counterexamples_count
        attr_reader :assertions_count, :errors_count, :failures_count

        def before_spec_file
          @spec_files_count += 1
        end

        def spec_file_error(e)
          @errors_count += 1
        end

        def after_each_done
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
            msg = colorize_success(msg)
          else
            msg = colorize_error(msg)
          end
          io.puts(msg)
          io.puts
        end

      private

        def success?
          @errors_count == 0 && @failures_count == 0
        end

      end # class Summary
    end # class Reporter
  end # class Tester
end # module Webspicy
