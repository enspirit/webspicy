module Webspicy
  class Tester
    class FileChecker < Tester

      def default_reporter
        @reporter = Reporter::Composite.new
        @reporter << Reporter::FileProgress.new
        @reporter << Reporter::Exceptions.new
        @reporter << Reporter::FileSummary.new
        @reporter << Reporter::ErrorCount.new
      end

      def run_scope
        scope.each_specification_file do |spec_file|
          @specification = load_specification(spec_file)
          reporter.spec_file_done
        end
      end

    end # class FileChecker
  end # class Tester
end # module Webspicy
