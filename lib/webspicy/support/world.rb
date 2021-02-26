module Webspicy
  module Support
    class World < OpenStruct

      def initialize(folder)
        super({})
        @folder = folder
      end
      attr_reader :folder

      def method_missing(name, *args, &bl)
        return super if name =~ /=$/
        file = ['json', 'yml', 'yaml']
          .map{|e| folder/"#{name}.#{e}" }
          .find{|f| f.file? }
        data = case file && file.ext
        when /json/
          JSON.parse(file.read, object_class: OpenStruct)
        when /ya?ml/
          JSON.parse(file.load.to_json, object_class: OpenStruct)
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

    end # class World
  end # module Support
end # module Webspicy
