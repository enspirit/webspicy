module Webspicy
  module Support
    class StatusRange

      def initialize(range)
        @range = range
      end
      attr_reader :range

      def self.int(i)
        new(i..i)
      end

      def to_int
        @range.first
      end

      def self.str(s)
        from = s[/^(\d)/,1].to_i * 100
        new(from...from+100)
      end

      def to_str
        "#{@range.first/100}xx"
      end

      def to_i
        @range.first
      end

      def ===(status)
        range === status
      end

      def ==(other)
        other.is_a?(StatusRange) && self.range == other.range
      end
      alias :eql? :==

      def hash
        @range.hash
      end

    end # class StatusRange
  end # module Support
end # module Webspicy
