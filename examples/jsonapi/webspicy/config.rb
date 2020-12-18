Finitio.stdlib_path(Path.dir/"schema")

RSpec.configure do |config|
  # RSpec automatically cleans stuff out of backtraces;
  # sometimes this is annoying when trying to debug something e.g. a gem
  config.backtrace_exclusion_patterns = [
    /\/lib\d*\/ruby\//,
    /bin\//,
    /gems/,
    /spec\/spec_helper\.rb/,
    /lib\/rspec\/(core|expectations|matchers|mocks)/,
    /\/Users\/llambeau\/Work\/Enspirit\/webspicy\/lib\//
  ]
end

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
