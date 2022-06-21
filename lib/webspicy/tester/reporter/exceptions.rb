module Webspicy
  class Tester
    class Reporter
      class Exceptions < Reporter
        include Documentation::Helpers

        def initialize(*args, &bl)
          super
          clear
        end
        attr_reader :failed_results, :spec_file_errors

        def spec_file_error(e)
          @spec_file_errors << spec_file_error_line(spec_file, e)
        end

        def test_case_done
          @failed_results << result unless result.success?
        end

        def report
          report_spec_file_errors
          report_failed_results
        end

        def clear
          @spec_file_errors = []
          @failed_results = []
        end

      private

        def report_spec_file_errors
          return if spec_file_errors.empty?
          io.puts
          io.puts "Invalid specs:"
          io.puts
          spec_file_errors.each do |e|
            io.puts e
          end
          io.puts
          io.flush
        end

        def report_failed_results
          return if failed_results.empty?
          io.puts
          io.puts "Exceptions:"
          io.puts
          failed_results.each_with_index do |result,i|
            io.puts service_line(result.service, result.test_case)
            result.failures.each do |(c,e)|
              io.puts check_failure_line(c,e)
            end
            result.errors.each do |(c,e)|
              io.puts check_error_line(c,e)
              io.puts e.backtrace.join("\n").gsub(/^/, "  ") if e.backtrace
            end
            io.puts
          end
          io.puts
          io.flush
        end

      end # class Exceptions
    end # class Reporter
  end # class Tester
end # module Webspicy
