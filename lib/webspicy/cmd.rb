module Webspicy
  module Cmd

    require_relative 'cmd/specification'

    FORMALDOC = Finitio.system(Path.dir/("cmd/formaldoc.fio"))

    def specification(raw, file = nil, scope = Webspicy.default_scope)
      raw = YAML.load(raw) if raw.is_a?(String)
      Webspicy.with_scope(scope) do
        r = FORMALDOC["Specification"].dress(raw)
        r.config = scope.config
        r.located_at!(file) if file
        r
      end
    rescue Finitio::Error => ex
      handle_finitio_error(ex)
    end
    module_function :specification

    def service(raw, scope = Webspicy.default_scope)
      Webspicy.with_scope(scope) do
        FORMALDOC["Service"].dress(raw)
      end
    rescue Finitio::Error => ex
      handle_finitio_error(ex)
    end
    module_function :service

    def test_case(raw, scope = Webspicy.default_scope)
      Webspicy.with_scope(scope) do
        FORMALDOC["TestCase"].dress(raw)
      end
    rescue Finitio::Error => ex
      handle_finitio_error(ex)
    end
    module_function :test_case

    def handle_finitio_error(ex)
      raise ex
    end
    module_function :handle_finitio_error

  end # module Cmd
end # module Webspicy
