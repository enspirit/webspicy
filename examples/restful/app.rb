require 'sinatra'
require 'json'
require 'path'
require 'finitio'

SCHEMA = Finitio::DEFAULT_SYSTEM.parse (Path.dir/'webspicy/schema.fio').read

TODOLIST = [
  {
    id: 1,
    description: "Refactor the framework"
  },
  {
    id: 2,
    description: "Write documentation"
  }
]

disable :show_exceptions
enable :raise_errors

get '/todo/' do
  content_type :json
  TODOLIST.to_json
end

post '/todo/' do
  content_type :json
  todo = SCHEMA["Todo"].dress(JSON.load(request.body.read))
  if TODOLIST.find{|t| t[:id] == todo[:id] }
    status 409
    {error: "Identifier already in use"}.to_json
  else
    TODOLIST << todo
    status 201
    todo.to_json
  end
end

get '/todo/:id' do |id|
  content_type :json
  todo = TODOLIST.find{|todo| todo[:id] == Integer(id) }
  if todo.nil?
    status 404
    {error: "No such todo"}.to_json
  else
    todo.to_json
  end
end
