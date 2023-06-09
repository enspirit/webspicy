module Webspicy
  class Tester
    module Assertions

      class InvalidArgError < StandardError; end

      NO_ARG = Object.new

      def includes(target, path, expected = NO_ARG)
        path, expected = '', path if expected == NO_ARG
        target = extract_path(target, path)
        an_array(target).include?(expected)
      end

      def notIncludes(target, path, expected = NO_ARG)
        not self.includes(target, path, expected)
      end

      def exists(target, path = NO_ARG)
        target = extract_path(target, path)
        not target.nil?
      end

      def notExists(target, path = NO_ARG)
        target = extract_path(target, path)
        target.nil?
      end

      def empty(target, path = NO_ARG)
        target = extract_path(target, path)
        respond_to!(target, :empty?).empty?
      end

      def notEmpty(target, path = NO_ARG)
        not empty(target, path)
      end

      def size(target, path, expected = NO_ARG)
        path, expected = '', path if expected == NO_ARG
        actual_size(target, path) == expected
      end

      def actual_size(target, path)
        target = extract_path(target, path)
        respond_to!(target, :size).size
      end

      def idIn(target, path, expected = NO_ARG)
        path, expected = '', path if expected == NO_ARG
        target = extract_path(target, path)
        ids = an_array(target).map do |tuple|
          respond_to!(tuple, :[])[:id]
        end
        ids.to_set == expected.to_set
      end

      def idNotIn(target, path, expected = NO_ARG)
        path, expected = '', path if expected == NO_ARG
        target = extract_path(target, path)
        ids = an_array(target).map do |tuple|
          respond_to!(tuple, :[])[:id]
        end
        (ids.to_set & expected.to_set).empty?
      end

      def element_with_id(target, path, id)
        target = extract_path(target, path)
        an_array(target).find { |t| t[:id] == id }
      end

      def idFD(element, expected)
        expected.keys.all? do |k|
          value_equal(expected[k], element[k])
        end
      end

      def pathFD(target, path, expected)
        target = extract_path(target, path)
        expected.keys.all?{|k|
          value_equal(expected[k], target[k])
        }
      end

      def match(target, path, rx)
        target = extract_path(target, path)
        !(target.to_s =~ rx).nil?
      end

      def notMatch(target, path, rx)
        !match(target, path, rx)
      end

      def eq(target, path, expected)
        target = extract_path(target, path)
        target == expected
      end

      def eql(target, path, expected)
        target = extract_path(target, path)
        value_equal(target, expected)
      end

    public

      def extract_path(target, path = NO_ARG)
        return target if path.nil? or path==NO_ARG or path.empty?
        return nil unless target.respond_to?(:[])
        path.split('/').inject(target) do |memo,key|
          memo && (memo.is_a?(Array) ? memo[key.to_i] : memo[key.to_sym])
        end
      end

    private

      def respond_to!(target, method)
        unless target.respond_to?(method)
          raise InvalidArgError, "Expecting instance responding to #{method}"
        end
        target
      end

      def an_array(target)
        target.is_a?(Array) ? target : [target]
      end

      def value_equal(exp, got)
        case exp
        when Hash
          exp.all?{|(k,v)| got[k] == v }
        else
          exp == got
        end
      end

    end # module Assertions
  end # class Tester
end # module Webspicy
