# 0.5.0

* BREAKING CHANGE: `RackTestClient#on` is removed. RackTestClient supports the standard
  host resolver mechanism instead. E.g., instead of:

  ```
  Configuration.new do |c|
    c.client = RackTestClient.for(Sinatra::Application).on("www.mywebapp.com")
  end
  ```

  Do:

  ```
  Configuration.new do |c|
    c.client = RackTestClient.for(Sinatra::Application)
    c.host = "http://www.mywebapp.com"
  end
  ```

  This allows having only mechanism instead of two, and lets you decide whether to use
  http or https.

# 0.4.0

* BREAKING CHANGE: before handlers only take two arguments (test_case, client) instead
  of 4. The service and resource can be obtained through the test_case itself, which now
  exposes the `#service` and `#resource` methods.

* Webspicy::Tester and Webspicy::Checker now support being constructed using a Path
  instance, and will load the configuration from a `config.rb` file found under that
  path. Note that the folder must unfortunately be passed as well in config.rb, e.g.
  `Configuration.new(Path.dir)`.

* Preconditions and postconditions are now optional in definition files. An array
  of Strings is supported in addition to a single String.

* Precondition handlers can be provided. Such handlers can both instrument existing
  test cases to meet preconditions, or generate additional counterexample test cases
  that violate preconditions on intent.

* Postcondition handlers can be provided too. Such handlers can check an invocation
  and assert specific conditions are met.

* RackTestClient now supports an explicit domain, to avoid having example.org
  as used by rack-test by default. E.g.,

  ```
  RackTestClient.for(Sinatra::Application).on("www.mywebapp.com")
  ```

  When setting a domain, rack-test is fed with absolute URLs instead of relative
  ones.

# 0.3.0

* The Configuration constructor now takes a required main folder as argument

* Configuration#add_folder disappears and is replaced by Configuration#folder,
  that is the equivalent of a dup on a new sub-folder. This allows for the following
  multi-folder scenarii:

  ```
  Configuration.new(Path.dir/'webspicy') do |c|
    c.folder 'api' do |api|
      api.client = Webspicy::RackTestClient.for(::Sinatra::Application)
    end
    c.folder 'web' do |web|
      ...
    end
  end
  ```

* Webspicy.resource, Webspicy.service and Webspicy.test_case now take an optional
  scope as last argument, scope that is installed and used for Finitio resolving.