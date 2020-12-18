Finitio.stdlib_path(Path.dir/"schema")

def webspicy_config(&bl)
  Webspicy::Configuration.new(Path.dir) do |c|
    #c.precondition MustBeAuthenticated
    c.host = "http://127.0.0.1:4567"
    c.client = Webspicy::Tester::HttpClient
    c.precondition Webspicy::Specification::Precondition::RobustToInvalidInput.new
    bl.call(c) if bl
  end
end
webspicy_config
