module Webspicy
  module Support
    module RSpecRunnable

      def initialize(config)
        @config = Configuration.dress(config)
      end
      attr_reader :config

      def reset_rspec!
        RSpec.reset
        RSpec.configure do |c|
          c.filter_gems_from_backtrace "rake"
        end
        load_rspec_examples
      end

      def call(err=$stderr, out=$stdout)
        reset_rspec!
        options = RSpec::Core::ConfigurationOptions.new(config.rspec_options)
        conf = RSpec::Core::Configuration.new
        RSpec::Core::Runner.new(options, conf).run(err, out)
      end

    end # module RSpecRunnable
  end # module Support
end # module Webspicy
