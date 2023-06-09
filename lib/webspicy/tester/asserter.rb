module Webspicy
  class Tester
    class Asserter

      NO_ARG = Object.new

      class AssertionsClass
        include Assertions
      end

      def initialize(target)
        @target = target
        @assertions = AssertionsClass.new
      end

      def includes(path, expected = NO_ARG)
        path, expected = '', path if expected == NO_ARG
        unless @assertions.includes(@target, path, expected)
          _! "Expected #{_s(@target, path)} to include #{expected}"
        end
      end

      def notIncludes(path, expected = NO_ARG)
        path, expected = '', path if expected == NO_ARG
        unless @assertions.notIncludes(@target, path, expected)
          _! "Expected #{_s(@target, path)} not to include #{expected}"
        end
      end

      def exists(path = '')
        unless @assertions.exists(@target, path)
          _! "Expected #{_s(@target, path)} to exists"
        end
      end

      def notExists(path = '')
        unless @assertions.notExists(@target, path)
          _! "Expected #{_s(@target, path)} not to exists"
        end
      end

      def empty(path = '')
        unless @assertions.empty(@target, path)
          _! "Expected #{_s(@target, path)} to be empty"
        end
      end

      def notEmpty(path = '')
        unless @assertions.notEmpty(@target, path)
          _! "Expected #{_s(@target, path)} to be non empty"
        end
      end

      def size(path, expected = NO_ARG)
        path, expected = '', path if expected == NO_ARG
        unless @assertions.size(@target, path, expected)
          actual = @assertions.actual_size(@target, path)
          _! "Expected #{_s(@target, path)} to have a size of #{expected}, actual size is: #{actual}"
        end
      end

      def idIn(path, *expected)
        path, expected = '', [path]+expected unless path.is_a?(String)
        unless @assertions.idIn(@target, path, expected)
          _! "Expected #{_s(@target, path)} to have ids #{expected.join(',')}"
        end
      end

      def idNotIn(path, *expected)
        path, expected = '', [path]+expected unless path.is_a?(String)
        unless @assertions.idNotIn(@target, path, expected)
          _! "Expected #{_s(@target, path)} to not have ids #{expected.join(',')}"
        end
      end

      def idFD(path, id, expected = NO_ARG)
        if expected == NO_ARG
          expected = id
          id, path = path, ''
        end
        element = @assertions.element_with_id(@target, path, id)
        unless element
          _! "Expected an element with id #{id} to contain the key(s) and value(s) #{expected}, but there is no element with that id"
        end

        unless @assertions.idFD(element, expected)
          _! "Expected #{_s(@target, path)} to contain the key(s) and value(s) #{expected}"
        end
      end

      def pathFD(path, expected)
        unless @assertions.pathFD(@target, path, expected)
          _! "Expected #{_s(@target, path)} to contain the key(s) and value(s) #{expected}"
        end
      end

      def match(path, expected = NO_ARG)
        path, expected = '', path if expected == NO_ARG
        unless @assertions.match(@target, path, expected)
          _! "Expected #{_s(@target, path)} to match #{expected.inspect}"
        end
      end

      def notMatch(path, expected = NO_ARG)
        path, expected = '', path if expected == NO_ARG
        unless @assertions.notMatch(@target, path, expected)
          _! "Expected #{_s(@target, path)} not to match #{expected.inspect}"
        end
      end

      def eq(path, expected = NO_ARG)
        path, expected = '', path if expected == NO_ARG
        target = @assertions.extract_path(@target, path)
        Predicate.eq(target, expected).assert!
      end

      def eql(path, expected = NO_ARG)
        path, expected = '', path if expected == NO_ARG
        target = @assertions.extract_path(@target, path)
        Predicate.eq(target, expected).assert!
      end

    private

      def DateTime(str)
        DateTime.parse(str)
      end

      def Date(str)
        Date.parse(str)
      end

      def _s(target, path)
        result = @assertions.extract_path(target, path)
        result = result.to_json
        result = result[0..25] + "..." if result.size>25
        result
      end

      def _!(msg)
        raise Failure, msg
      end

    end # class Asserter
  end # class Tester
end # module Webspicy

