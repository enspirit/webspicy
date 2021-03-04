module Webspicy
  class Specification
    module Condition

      MATCH_ALL = "__all__"

      attr_accessor :matching_description

      def to_s
        if matching_description == MATCH_ALL
          self.class.name
        else
          matching_description
        end
      end

      SORL_OPTS = { max: 5, wait: 0.05, raise: false }

      def sooner_or_later(opts = nil)
        opts = SORL_OPTS.merge(opts || {})
        left, wait_ms = opts[:max], opts[:wait]
        until (r = yield) || left == 0
          sleep(wait_ms)
          wait_ms, left = wait_ms*2, left - 1
        end
        raise TimeoutError, "Timeout on sooner-or-later" if r.nil? && opts[:raise]
        r
      end

    end # module Condition
  end # class Specification
end # module Webspicy
