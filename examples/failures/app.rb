require 'sinatra'

VALID_RESPONSE = {
  ok: true,
  hobbies: [ "programming", "quality", "testing" ]
}

get '/' do
  status 200
  content_type :json
  headers('X-Hello' => "World")
  VALID_RESPONSE.to_json
end

get '/missing-attribute' do
  status 200
  content_type :json
  VALID_RESPONSE.reject{|k,v| k == :hobbies }.to_json
end

get '/extra-attribute' do
  status 200
  content_type :json
  VALID_RESPONSE.merge(foo: "bar").to_json
end

get '/wrong-attribute-type' do
  status 200
  content_type :json
  VALID_RESPONSE.merge(ok: 12).to_json
end
