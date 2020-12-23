module Webspicy
  class Tester
    class Reporter
      include Support::Colorize

      def initialize(io = STDOUT)
        @io = io
      end
      attr_reader :io

      def init(tester)
        @tester = tester
      end
      attr_reader :tester

      [
        :config,
        :scope,
        :client,
        :spec_file,
        :specification,
        :service,
        :test_case,
        :invocation,
        :result
      ].each do |meth|
        define_method(meth) do |*args, &bl|
          tester.send(meth, *args, &bl)
        end
      end

      HOOKS = [
        :before_all,
        :before_all_done,
        :before_scope,
        :scope_done,
        :before_spec_file,
        :spec_file_error,
        :spec_file_done,
        :before_specification,
        :specification_done,
        :before_service,
        :service_done,
        :before_test_case,
        :test_case_done,
        :before_each,
        :before_each_done,
        :before_instrument,
        :instrument_done,
        :before_invocation,
        :invocation_done,
        :before_assertions,
        :check_success,
        :check_failure,
        :check_error,
        :assertions_done,
        :after_each,
        :after_each_done,
        :after_all,
        :after_all_done,
        :report
      ]

      HOOKS.each do |meth|
        define_method(meth){|*args, &bl|
        }
      end

    protected

      def plural(word, count)
        "%d #{word}#{count>1 ? 's' : ''}" % [count]
      end

    end # class Reporter
  end # class Tester
end # module Webspicy
require_relative 'reporter/progress'
require_relative 'reporter/summary'
require_relative 'reporter/documentation'
require_relative 'reporter/exceptions'
require_relative 'reporter/composite'
require_relative 'reporter/file_progress'
require_relative 'reporter/file_summary'
