module Webspicy
  module Web
    class Specification
      module Post
        class LastModifiedCachingProtocol
          include Webspicy::Specification::Post

          MATCH = /It supports the Last-Modified\/If-Modified-Since caching protocol/

          def self.match(service, descr)
            return nil unless descr =~ MATCH
            LastModifiedCachingProtocol.new
          end

          def check!
            res = invocation.response
            last_modified = res.headers['Last-Modified']
            fail!("No last-modified response header found") unless last_modified

            # check it fits the HTTP-date format or fail
            Time.httpdate(last_modified) rescue fail!("Not valid Last-Modified response header")

            url, _ = test_case.specification.instantiate_url(test_case.params)
            url = scope.to_real_url(url, test_case){|u,_| u }

            response = client.api.get(url, {}, test_case.headers.merge({
              'If-Modified-Since' => last_modified
            }))
            fail!("304 expected") unless response.status == 304

            response = client.api.get(url, {}, test_case.headers.merge({
              'If-Modified-Since' => "Thu, 08 Jun 1970 19:06:27 GMT"
            }))
            fail!("2xx expected") if response.status == 304
          end

        end # class LastModifiedCachingProtocol
      end # module Post
    end # module Webspicy
  end # module Web
end # class Specification
