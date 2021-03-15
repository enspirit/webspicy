module Webspicy
  module Support
    module Colorize

      def colorize(str, kind, config = nil)
        return str if config && !config.colorize
        color = (config || self.config).colors[kind]
        Paint[str, color]
      end
      module_function :colorize

      def colorize_section(str, cfg = nil)
        colorize(str, :section, cfg)
      end
      module_function :colorize_section

      def colorize_highlight(str, cfg = nil)
        colorize(str, :highlight, cfg)
      end
      module_function :colorize_highlight

      def colorize_success(str, cfg = nil)
        colorize(str, :success, cfg)
      end
      module_function :colorize_success

      def colorize_error(str, cfg = nil)
        colorize(str, :error, cfg)
      end
      module_function :colorize_error

    end # module Colorize
  end # module Support
end # module Webspicy
