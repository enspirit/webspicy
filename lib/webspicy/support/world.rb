module Webspicy
  module Support
    class World < OpenStruct

      def initialize(folder, config = nil)
        super({})
        @folder = folder
        @config = config
      end
      attr_reader :folder, :config

      def method_missing(name, *args, &bl)
        return super if name =~ /=$/
        file = ['json', 'yml', 'yaml', 'rb']
          .map{|e| folder/"#{name}.#{e}" }
          .find{|f| f.file? }
        data = case file && file.ext
        when /json/
          JSON.parse(file.read, object_class: OpenStruct)
        when /ya?ml/
          JSON.parse(file.load.to_json, object_class: OpenStruct)
        when /rb/
          ::Kernel.eval(file.read).tap{|x|
            x.config = self.config if x.is_a?(Item)
          }
        end
        self.send(:"#{name}=", data)
      end

      def to_data(which)
        case which
        when Hash
          OpenStruct.new(which)
        when Array
          which.map{|x| to_data(x) }
        else
          which
        end
      end

      module Item
        attr_accessor :config
      end # module Item

    end # class World
  end # module Support
end # module Webspicy
