require 'webspicy/web/specification/pre/global_request_headers'
require 'webspicy/web/specification/pre/robust_to_invalid_input'
require 'webspicy/web/specification/post/last_modified_caching_protocol'
require 'webspicy/web/specification/post/etag_caching_protocol'

def webspicy_config(&bl)
  Webspicy::Configuration.new(Path.dir) do |c|
    root_folder = Path.backfind('.[webspicy.gemspec]')
    test_results, my_name = root_folder/"test-results", Path.dir.dir.basename
    c.reporter << Webspicy::Tester::Reporter::JunitXmlFile.new(test_results/"#{my_name}.xml")

    c.precondition MustBeAuthenticated
    c.precondition MustBeAnAdmin

    c.precondition Webspicy::Web::Specification::Pre::GlobalRequestHeaders.new({
      'Accept' => 'application/json'
    }){|service| service.method == "GET" }

    c.precondition Webspicy::Web::Specification::Pre::RobustToInvalidInput.new

    c.postcondition Webspicy::Web::Specification::Post::LastModifiedCachingProtocol
    c.postcondition Webspicy::Web::Specification::Post::ETagCachingProtocol

    c.postcondition TodoRemoved
    c.errcondition  TodoNotRemoved

    c.instrument do |tester|
      tc = tester.test_case
      role = tc.metadata[:role]
      tc.headers['Authorization'] = "Bearer #{role}" if role
    end

    bl.call(c) if bl
  end
end
webspicy_config
