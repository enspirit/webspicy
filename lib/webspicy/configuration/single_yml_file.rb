module Webspicy
  class Configuration
    class SingleYmlFile < Configuration

      class SingleYmlFileScope < Scope

        def initialize(config, file)
          super(config)
          @file = file
        end
        attr_reader :file

        def each_specification(&bl)
          return enum_for(:each_specification) unless block_given?
          yield Webspicy.specification(file.read, nil, self)
        end

      end # class SingleYmlFileScope

      def initialize(file)
        folder = file.backfind("[config.rb]")
        super(folder || Path.pwd)
        @file = file
      end

      def factor_scope
        SingleYmlFileScope.new(self, @file)
      end

    end # class SingleYmlFile
  end # class Configuration
end # module Webspicy
