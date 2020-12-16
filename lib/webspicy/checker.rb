module Webspicy
  class Checker

    def initialize(config)
      @config = Configuration.dress(config)
    end
    attr_reader :config

    def call
      config.each_scope do |scope|
        scope.each_specification_file do |file, folder|
          RSpec.describe file.relative_to(folder).to_s do

            it 'meets the formal doc data schema' do
              Webspicy.specification(file.load, file, scope)
            end

          end
        end
      end
      RSpec::Core::Runner.run config.rspec_options
    end

  end
end
