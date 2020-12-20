module Webspicy
  module Support
    module DataObject

      def initialize(raw)
        @raw = raw
      end
      attr_accessor :raw
      protected :raw, :raw=

      def method_missing(name, *args, &bl)
        if @raw.has_key?(name) && args.empty? && bl.nil?
          @raw[name]
        else
          super
        end
      end

      def to_info
        @raw
      end

    end # module DataObject
  end # module Support
end # module Webspicy
