module Webspicy
  class RestClient

    attr_reader :token    
    attr_reader :last_response

    def initialize(host = "http://127.0.0.1:4567")
      @host = host
      @token = nil
      @last_response = nil
    end

    def get(url, params, headers = nil)
      headers, url = headers_and_url_for(url, params, headers)

      Webspicy.info("GET #{url} -- #{params.inspect}")

      @last_response = HTTP[headers].get(url, params: params)

      Webspicy.debug("Headers: #{@last_response.headers.to_hash}")
      Webspicy.debug("Response: #{@last_response.body}")
    end

    def post(url, params, headers = nil)
      headers, url = headers_and_url_for(url, params, headers)

      Webspicy.info("POST #{url} -- #{params.inspect}")

      @last_response = HTTP[headers].post(url, body: params.to_json)

      Webspicy.debug("Headers: #{@last_response.headers.to_hash}")
      Webspicy.debug("Response: #{@last_response.body}")
    end

    def post_form(url, params, headers = nil)
      headers, url = headers_and_url_for(url, params, headers)

      Webspicy.info("POST #{url} -- #{params.inspect}")

      @last_response = HTTP[headers].post(url, form: params)

      Webspicy.debug("Headers: #{@last_response.headers.to_hash}")
      Webspicy.debug("Response: #{@last_response.body}")
    end

  private

    def headers_and_url_for(url, params, headers)
      headers = headers || {}
      url = url =~ /^http/ ? url : "#{@host}#{url}"
      [ headers, url ]
    end

  end # class RestClient
end # module Webspicy
