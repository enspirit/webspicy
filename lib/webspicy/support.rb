module Webspicy
  module Support

    SORL_OPTS = { max: 5, wait: 0.05, raise: false }

    def sooner_or_later(opts = nil, &bl)
      opts = SORL_OPTS.merge(opts || {})
      left, wait_ms = opts[:max], opts[:wait]
      r = _sooner_or_later(&bl)
      until (r && !r.is_a?(Tester::Failure)) || left == 0
        sleep(wait_ms)
        wait_ms, left = wait_ms*2, left - 1
        r = _sooner_or_later(&bl)
      end
      raise r if r.is_a?(Tester::Failure)
      raise TimeoutError, "Timeout on sooner-or-later" if r.nil? && opts[:raise]
      r
    end
    module_function :sooner_or_later

    def _sooner_or_later(&bl)
      bl.call
    rescue Tester::Failure => ex
      ex
    end
    module_function :_sooner_or_later

  end # module Support
end # module Webspicy
require_relative 'support/data_object'
require_relative 'support/status_range'
require_relative 'support/colorize'
require_relative 'support/world'
require_relative 'support/hooks'
