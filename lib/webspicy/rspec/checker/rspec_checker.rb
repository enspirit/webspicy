module Webspicy
  class Checker
    class RSpecChecker
      include Webspicy::Support::RSpecRunnable

    protected

      def load_rspec_examples
        config.each_scope do |scope|
          scope.each_specification_file do |file, folder|
            RSpec.describe file.relative_to(folder).to_s do

              it 'meets the formal doc data schema' do
                Webspicy.specification(file.load, file, scope)
              end

            end
          end
        end
      end

    end # class RSpecChecker
  end # class Checker
end # module Webspicy
