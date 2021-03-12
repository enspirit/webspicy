def webspicy_config(&bl)
  Webspicy::Configuration.new(Path.dir) do |c|

    c.precondition MustBeAuthenticated
    c.precondition MustBeAnAdmin

    c.precondition Webspicy::Specification::Pre::GlobalRequestHeaders.new({
      'Accept' => 'application/json'
    }){|service| service.method == "GET" }

    c.precondition Webspicy::Specification::Pre::RobustToInvalidInput.new

    c.postcondition TodoRemoved
    c.errcondition  TodoNotRemoved

    c.instrument do |t|
      tc = t.test_case
      role = tc.metadata[:role]
      tc.headers['Authorization'] = "Bearer #{role}" if role
    end

    bl.call(c) if bl
  end
end
webspicy_config
