Finitio.stdlib_path(Path.dir/"schema")

def webspicy_config(&bl)
  Webspicy::Configuration.new(Path.dir) do |c|
    #c.precondition MustBeAuthenticated
    c.precondition Webspicy::Specification::Precondition::RobustToInvalidInput.new
    bl.call(c) if bl
  end
end
webspicy_config
