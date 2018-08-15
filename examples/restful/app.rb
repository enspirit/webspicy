require 'sinatra'
require 'json'
require 'path'
require 'finitio'
require 'rack/robustness'
require 'csv'

SCHEMA = Finitio::DEFAULT_SYSTEM.parse (Path.dir/('webspicy/schema.fio')).read

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

set :todolist, TODOLIST.dup

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

post '/reset' do
  settings.todolist = TODOLIST.dup
  status 200
  ""
end

get '/todo/' do
  content_type :json
  settings.todolist.to_json
end

post '/todo/', :auth => :user do
  content_type :json
  case todos = loaded_body
  when Array
    n = 0
    todos.each do |todo|
      settings.todolist << todo
      n += 1
    end
    status 201
    { count: n }.to_json
  when Hash
    todo = SCHEMA["Todo"].dress(todos)
    if settings.todolist.find{|t| t[:id] == todo[:id] }
      status 409
      {error: "Identifier already in use"}.to_json
    else
      settings.todolist << todo
      status 201
      todo.to_json
    end
  end
end

get '/todo/:id' do |id|
  content_type :json
  todo = settings.todolist.find{|todo| todo[:id] == Integer(id) }
  if todo.nil?
    status 404
    {error: "No such todo"}.to_json
  else
    todo.to_json
  end
end

patch '/todo/:id', :auth => :user do |id|
  content_type :json
  todo = settings.todolist.find{|todo| todo[:id] == Integer(id) }
  if todo.nil?
    status 404
    {error: "No such todo"}.to_json
  else
    patch = SCHEMA["TodoPatch"].dress(loaded_body)
    patched = todo.merge(patch)
    settings.todolist = settings.todolist.reject{|todo| todo[:id] == Integer(id) }
    settings.todolist << patched
    patched.to_json
  end
end

delete '/todo/:id', :auth => :admin do |id|
  content_type :json
  todo = settings.todolist.find{|todo| todo[:id] == Integer(id) }
  if todo.nil?
    status 404
    {error: "No such todo"}.to_json
  else
    settings.todolist = settings.todolist.reject{|todo| todo[:id] == Integer(id) }
    status 204
    content_type "text/plain"
  end
end

###

def loaded_body
  case ctype = request.content_type
  when /json/
    JSON.load(request.body.read)
  when /csv/
    csv = ::CSV.new(request.body.read, :headers => true, :header_converters => :symbol)
    csv.map {|row| row.to_hash }
  when /multipart\/form-data/
    file_body params[:file]
  else
    halt [415,{},["Unsupported content type: `#{ctype}`"]]
  end
end

def file_body(file)
  ctype = Path(file[:filename] || file["filename"]).extname
  ctype = (file[:type] || file["type"]) if ctype.nil? or ctype.empty?
  case ctype
  when /csv/
    str = file[:tempfile].read
    csv = ::CSV.new(str, :headers => true, :header_converters => :symbol)
    csv.map {|row| row.to_hash }
  else
    halt [415,{},["Unsupported content type: `#{ctype}`\n#{file.inspect}"]]
  end
end
