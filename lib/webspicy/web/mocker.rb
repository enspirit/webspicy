require "finitio/generation"
require "json"
module Webspicy
  class Mocker

    def initialize(config)
      @config = Configuration.dress(config)
      @generator = config.generator || Finitio::Generation.new
    end
    attr_reader :config, :generator

    def call(env)
      req = Rack::Request.new(env)
      path = req.path
      meth = req.request_method
      if meth == "OPTIONS" && has_service?(path)
        [204, {}, []]
      elsif service = find_service(meth, path)
        status = best_status_code(service)
        body = status == 204 ? "" : random_body(service, req)
        headers = generate_headers(service)
        [ status, headers, [ body ].compact ]
      else
        [404, {}, []]
      end
    end

  private

    def has_service?(path)
      config.each_scope do |scope|
        scope.each_specification do |specification|
          next unless url_matches?(specification, path)
          return true
        end
      end
      return false
    end

    def find_service(method, path)
      config.each_scope do |scope|
        scope.each_specification do |specification|
          next unless url_matches?(specification, path)
          scope.each_service(specification) do |service|
            return service if service.method == method
          end
        end
      end
      nil
    end

    def generate_headers(service)
      {
        "Content-Type" => best_content_type(service)
      }.delete_if{|k,v| v.nil? }
    end

    def best_status_code(service)
      if ex = service.examples.first
        (ex.expected_status && ex.expected_status.to_i) || 200
      else
        200
      end
    end

    def best_content_type(service)
      if ex = service.examples.first
        ex.expected_content_type
      else
        "application/json"
      end
    end

    def url_matches?(specification, path)
      specification.url_pattern.match(path)
    end

    def random_body(service, request)
      world = OpenStruct.new({
        service: service,
        request: request
      })
      data = generator.call(service.output_schema.main, world)
      JSON.pretty_generate(data) if data
    end

  end # class Mocker
end # module Webspicy
