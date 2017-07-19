module Webspicy
  class Checker

    def initialize(config)
      @config = config
    end
    attr_reader :config

    def call
      Webspicy.with_scope_for(config) do |scope|
        client = scope.get_client
        scope.each_resource_file do |file, folder|
          RSpec.describe file.relative_to(folder).to_s do

            it 'meets the formal doc data schema' do
              Webspicy.resource(file.load, file)
            end

          end
        end
        RSpec::Core::Runner.run config.rspec_options
      end
    end

  end
end
