def webspicy_config(&bl)
  Webspicy::Configuration.new(Path.dir) do |c|
    root_folder = Path.backfind('.[webspicy.gemspec]')
    test_results, my_name = root_folder/"test-results", Path.dir.dir.basename
    c.reporter << Webspicy::Tester::Reporter::JunitXmlFile.new(test_results/"#{my_name}.xml")

    c.precondition MustBeAuthenticated
    c.precondition MustBeAnAdmin

    c.precondition Webspicy::Specification::Pre::GlobalRequestHeaders.new({
      'Accept' => 'application/json'
    }){|service| service.method == "GET" }

    c.precondition Webspicy::Specification::Pre::RobustToInvalidInput.new

    c.postcondition TodoRemoved
    c.errcondition  TodoNotRemoved

    c.instrument do |tester|
      tc = tester.test_case
      role = tc.metadata[:role]
      puts tc.headers.object_id
      tc.headers['Authorization'] = "Bearer #{role}" if role
    end

    bl.call(c) if bl
  end
end
webspicy_config
