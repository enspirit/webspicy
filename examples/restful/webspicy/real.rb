require_relative 'config'
webspicy_config do |c|
  c.host = "http://127.0.0.1:4567"
  c.client = Webspicy::Web::HttpClient
  c.before_each do |_,client|
    client.api.post "http://127.0.0.1:4567/reset"
  end
end
