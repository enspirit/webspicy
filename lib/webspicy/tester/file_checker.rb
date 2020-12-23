module Webspicy
  class Tester
    class FileChecker < Tester

      def default_reporter
        @reporter = Tester::Reporter::Composite.new
        @reporter << Tester::Reporter::FileProgress.new
        @reporter << Tester::Reporter::Exceptions.new
        @reporter << Tester::Reporter::FileSummary.new
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
