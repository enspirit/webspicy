module Webspicy
  module Support
    module Colorize

      def colorize(str, kind)
        color = config.colors[kind]
        ColorizedString[str].colorize(color)
      end

      def colorize_highlight(str)
        colorize(str, :highlight)
      end

      def colorize_success(str)
        colorize(str, :success)
      end

      def colorize_error(str)
        colorize(str, :error)
      end

    end # module Colorize
  end # module Support
end # module Webspicy
