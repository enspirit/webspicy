def webspicy_config(&bl)
  Webspicy::Configuration.new(Path.dir) do |c|

    c.precondition MustBeAuthenticated
    c.precondition MustBeAnAdmin

    c.instrument do |tc, client|
      role = tc.metadata[:role]
      tc.headers['Authorization'] = "Bearer #{role}" if role
    end

    bl.call(c) if bl
  end
end
webspicy_config
