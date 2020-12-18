require 'webspicy'
require 'sinatra'
require 'json'
require 'path'
require 'finitio'
require 'finitio/generation'
require 'rack/robustness'
require 'csv'

Finitio.stdlib_path(Path.dir/"webspicy/schema")

SCHEMA = Finitio.system (Path.dir/'webspicy/schema.fio').read

disable :show_exceptions
enable :raise_errors

# generator = Finitio::Generation.new
# people = generator.call(SCHEMA['Output'], {})
# puts JSON.pretty_generate(people)

set(:auth) do |role|
  condition do
    token = env['HTTP_AUTHORIZATION']
    case token
    when NilClass
      halt [
        401,
        {'Content-Type' => 'application/json'},
        [{ error: "Please log in first" }.to_json]
      ]
    when "Bearer #{role}"
      true
    else
      halt [
        401,
        {'Content-Type' => 'application/json'},
        [{ error: "#{role.capitalize} required" }.to_json]
      ]
    end
  end
end

use Rack::Robustness do |g|
  g.no_catch_all
  g.status 400
  g.content_type 'application/json'
  g.body{|ex| { error: ex.message }.to_json }
  g.on(Finitio::TypeError)
end

options '*' do
  status 204
  ""
end

persons = (Path.dir/"fixtures").glob("*.json").map{|p|
  p.load
}

get '/people' do
  status 200
  content_type :json
  JSON.pretty_generate({
    data: persons.map{|p| p.reject{|k| k == "curriculum" } },
    links: {
      "self": "/people"
    }
  })
end

get '/people/:id' do |id|
  status 200
  p = persons.find{|p| p['id'] == id }
  if p
    content_type :json
    status 200
    JSON.pretty_generate(p)
  else
    content_type "text/plain"
    status 404
    "Not Found"
  end
end
