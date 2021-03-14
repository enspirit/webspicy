module Webspicy
  class Configuration
    class SingleYmlFile

      class SingleYmlFileScope < Scope

        def initialize(config, file)
          super(config)
          @file = file
        end
        attr_reader :file

        def each_specification_file(*args, &bl)
          return enum_for(:each_specification_file) unless block_given?
          yield(file)
        end

        def each_specification(*args, &bl)
          return enum_for(:each_specification) unless block_given?
          yield Webspicy.specification(file.read, nil, self)
        end

      end # class SingleYmlFileScope

      def initialize(file)
        @file = file
      end

      def call(config)
        SingleYmlFileScope.new(config, @file)
      end

    end # class SingleYmlFile
  end # class Configuration
end # module Webspicy
