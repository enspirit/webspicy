module Webspicy
  class Client
    module Support

      def info_request(kind, url, params, headers, body)
        Webspicy.info("#{kind} #{url}")
        debug("Req params", JSON.pretty_generate(params)) if params
        debug("Req headers", JSON.pretty_generate(headers)) if headers
        debug("Req body", JSON.pretty_generate(body)) if body
        Webspicy.debug("")
      end

      def debug_response(response)
        debug("Res status", @last_response.status)
        debug("Res headers", JSON.pretty_generate(last_response.headers.to_h))
        debug("Res body", response_body_to_s(last_response))
        Webspicy.debug("")
      end

      def debug(what, value)
        Webspicy.debug("  #{what}: " + value_to_s(value))
      end

      def response_body_to_s(response)
        case response.content_type.to_s
        when /json/
          JSON.pretty_generate(JSON.load(response.body))
        else
          response.body.to_s
        end
      end

      def value_to_s(value)
        value.to_s.gsub(/\n/, "\n        ")
      end

    end # module Support
  end # class Client
end # module Webspicy
