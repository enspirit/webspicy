module Webspicy
  module Web

    FORMALDOC = Finitio.system(Path.dir/("web/formaldoc.fio"))

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
      puts ex.root_cause.message
      raise ex
    end
    module_function :handle_finitio_error

  end # module Web
end # module Webspicy
require_relative 'web/client'
require_relative 'web/invocation'
require_relative 'web/mocker'
require_relative 'web/openapi'
