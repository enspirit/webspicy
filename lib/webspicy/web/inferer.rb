require 'rack/proxy'
module Webspicy
  module Web
    class Inferer < Rack::Proxy

      def initialize(config, options = nil)
        @webspicy_config = config
        @webspicy_options = options || options_from_env
        super(proxy_options)
      end
      attr_reader :webspicy_config, :webspicy_options

      def rewrite_env(env)
        env = env.merge(static_env)
        env = handle_path_info(env)
        env
      end

      def rewrite_response(triplet)
        triplet
      end

      protected

      def options_from_env
        {
          target_endpoint: ENV['PROXY_TARGET_ENDPOINT'] || config.host
        }
      end

      def proxy_options
        uri = target_uri
        backend = "#{uri.scheme}://#{uri.host}"
        backend = "#{backend}:#{uri.port}" if uri.port != 80 && uri.port != 443
        {
          streaming: false,
          backend: backend
        }
      end

      def static_env
        @static_env ||= begin
          e = {}
          e['HTTP_HOST'] = target_uri.host
          e
        end
      end

      def target_uri
        @target_uri ||= URI.parse(webspicy_options[:target_endpoint])
      end

      def handle_path_info(env)
        return env if target_uri.path.nil? || target_uri.path.empty?

        env['PATH_INFO'] = "#{target_uri.path}#{env['PATH_INFO']}"
        env
      end

      def perform_request(env)
        webspicy_dump_request(env)
        super.tap{|triplet|
          webspicy_dump_response(env, triplet)
        }
      end

      def webspicy_dump_request(env)
        base_file = webspicy_dump_basefile(env)
        env['rack.input'].rewind
        input = ''
        env['rack.input'].each { |s| input << s }
        base_file.add_ext('.body').write(input)
        env['rack.input'].rewind
      end

      def webspicy_dump_response(env, triplet)
        base_file = webspicy_dump_basefile(env)
        base_file.add_ext('.env.json').write(
          JSON.pretty_generate(env)
        )
        base_file.add_ext('.triplet.json').write(
          JSON.pretty_generate(triplet)
        )
      end

      def webspicy_dump_basefile(env)
        path, method = env['PATH_INFO'], env['REQUEST_METHOD'].downcase
        target_folder = (webspicy_config.folder/'inferer'/'dump')/path[1..-1]
        target_folder.mkdir_p
        target_folder/"#{method}.#{Time.now.to_i}"
      end

    end # class Inferer
  end # module Web
end # module Webspicy
