require_relative 'config'
webspicy_config do |c|
  c.client = Webspicy::Tester::RackTestClient.for(::Sinatra::Application)
end
