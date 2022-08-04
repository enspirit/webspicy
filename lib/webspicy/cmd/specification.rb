module Webspicy
  module Cmd
    class Specification < Webspicy::Specification

      class << self
        def info(raw)
          new(raw)
        end

        def singleservice(raw)
          converted = {
            name: raw[:name] || "Unamed specification",
            command: raw[:command],
            services: [
              Webspicy::Cmd.service(raw.reject{|k| k==:command or k==:name }, Webspicy.current_scope)
            ]
          }
          info(converted)
        rescue => ex
          puts "Coucou: #{ex.message}"
          puts ex.backtrace.join("\n")
          raise
        end
      end

      def command
        @raw[:command]
      end

      def to_singleservice
        raise NotImplementedError
      end

    end # class Specification
  end # module Cmd
end # module Webspicy
require_relative 'specification/service'
require_relative 'specification/test_case'
