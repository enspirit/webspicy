def webspicy_config(&bl)
  Webspicy::Configuration.new(Path.dir) do |c|

    c.precondition MustBeAuthenticated
    c.precondition MustBeAnAdmin

    c.precondition Webspicy::Specification::Precondition::GlobalRequestHeaders.new({
      'Accept' => 'application/json'
    }){|service| service.method == "GET" }

    c.precondition Webspicy::Specification::Precondition::RobustToInvalidInput.new

    c.postcondition TodoRemoved
    c.errcondition  TodoNotRemoved

    c.instrument do |tc, client|
      role = tc.metadata[:role]
      tc.headers['Authorization'] = "Bearer #{role}" if role
    end

    bl.call(c) if bl
  end
end
webspicy_config
