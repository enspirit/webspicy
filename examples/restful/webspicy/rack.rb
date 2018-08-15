require_relative 'config'
webspicy_config do |c|
  c.client = Webspicy::RackTestClient.for(::Sinatra::Application)
  c.before_each do |_,client|
    client.api.post "/reset"
  end
end
