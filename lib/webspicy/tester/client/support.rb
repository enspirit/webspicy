module Webspicy
  class Tester
    class Client
      module Support
        include Webspicy::Support::Colorize

        NONE = Object.new

        def querystring_params(params)
          Hash[params.each_pair.map{|k,v| [k.to_s,v.to_s] }]
        end

        def info_request(kind, url, params, headers, body)
          Webspicy.info(colorize_highlight("~> #{kind} #{url}"))
          debug("  Req params", json_pretty(params)) if params
          debug("  Req headers", json_pretty(headers)) if headers
          debug("  Req body", request_body_to_s(body)) if body
        end

        def debug_response(response)
          debug(colorize_highlight("."))
          debug("  Res status", status_to_s(@last_response.status))
          debug("  Res headers", json_pretty(last_response.headers.to_h))
          debug("  Res body", response_body_to_s(last_response))
          Webspicy.debug("")
        end

        def debug(what, value = NONE)
          return Webspicy.debug("  #{what}") if value == NONE
          Webspicy.debug("  #{what}: " + value_to_s(value))
        end

        def request_body_to_s(body)
          body = body.to_info if body.is_a?(Webspicy::FileUpload)
          json_pretty(body)
        end

        def response_body_to_s(response)
          case response.content_type.to_s
          when /json/
            json_pretty(JSON.load(response.body))
          else
            response.body.to_s
          end
        end

        def value_to_s(value)
          value.to_s.gsub(/\n/, "\n      ")
        end

        def status_to_s(status)
          case status
          when 0 ... 400 then colorize_success(status.to_s)
          else colorize_error(status.to_s)
          end
        end

        def json_pretty(s)
          JSON.pretty_generate(s)
        end

      end # module Support
    end # class Client
  end # class Tester
end # module Webspicy
