module Webspicy
  class Tester
    class Reporter
      class FileSummary < Reporter

        def initialize(*args, &bl)
          super
          @spec_files_count = 0
          @errors_count = 0
        end
        attr_reader :spec_files_count, :errors_count

        def before_spec_file
          @spec_files_count += 1
        end

        def spec_file_error(e)
          @errors_count += 1
        end

        def report
          msg = "#{plural('spec file', spec_files_count)}, "\
                "#{plural('error', errors_count)}"
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
          @errors_count == 0
        end

      end # class FileSummary
    end # class Reporter
  end # class Tester
end # module Webspicy
