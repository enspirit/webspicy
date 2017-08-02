Webspicy::Configuration.inherits(Path.dir) do |c|
  c.host = "http://127.0.0.1:4567"
  c.client = Webspicy::HttpClient
  c.before_each do |_,client|
    client.api.post "http://127.0.0.1:4567/reset"
  end
end
