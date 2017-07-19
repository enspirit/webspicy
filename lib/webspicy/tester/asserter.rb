module Webspicy
  module Tester
    class Asserter

      NO_ARG = Object.new

      class AssertionsClass
        include Assertions
      end

      def initialize(target)
        @target = target
        @assertions = AssertionsClass.new
      end

      def exists(path = '')
        unless @assertions.exists(@target, path)
          _! "Expected #{_s(@target)} to exists"
        end
      end

      def notExists(path = '')
        unless @assertions.notExists(@target, path)
          _! "Expected #{_s(@target)} not to exists"
        end
      end

      def empty(path = '')
        unless @assertions.empty(@target, path)
          _! "Expected #{_s(@target)} to be empty"
        end
      end

      def notEmpty(path = '')
        unless @assertions.notEmpty(@target, path)
          _! "Expected #{_s(@target)} to be non empty"
        end
      end

      def size(path, expected = NO_ARG)
        path, expected = '', path if expected == NO_ARG
        unless @assertions.size(@target, path, expected)
          _! "Expected #{_s(@target)} to have a size of #{expected}"
        end
      end

      def idIn(path, *expected)
        path, expected = '', [path]+expected unless path.is_a?(String)
        unless @assertions.idIn(@target, path, expected)
          _! "Expected #{_s(@target)} to have ids #{expected.join(',')}"
        end
      end

      def idNotIn(path, *expected)
        path, expected = '', [path]+expected unless path.is_a?(String)
        unless @assertions.idNotIn(@target, path, expected)
          _! "Expected #{_s(@target)} to not have ids #{expected.join(',')}"
        end
      end

      def idFD(path, id, expected = NO_ARG)
        if expected == NO_ARG
          expected = id
          id, path = path, ''
        end
        unless @assertions.idFD(@target, path, id, expected)
          _! "Expected #{_s(@target)} to meet FD #{expected.inspect}"
        end
      end

      def pathFD(path, expected)
        unless @assertions.pathFD(@target, path, expected)
          _! "Expected #{_s(@target)} to meet FD #{expected.inspect}"
        end
      end

    private

      def DateTime(str)
        DateTime.parse(str)
      end

      def _s(target)
        target.inspect[0..25]
      end

      def _!(msg)
        raise msg
      end

    end # class Asserter
  end # module Tester
end # module Webspicy

