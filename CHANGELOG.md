# 0.14.0

* Add junit xml output by default.

# 0.13.1

* Show response status code in DEBUG log level.

* Catch fatal errors when collecting test expectations, to prevent all errors
  from being properly shown in test results.

# 0.13.0

* Adds an experimental Mocker abstraction that allows running a real API
  mock based on webspicy files.

# 0.12.5 - 2019/07/17

* RackTestClient now converts nil parameters to '' on GET requests. Before
  ruby 2.5.0, nil.dup raises an error and sinatra tries to duplicate param
  values on dispatch!.

# 0.12.4 - 2019/05/31

* Add Date coercer/asserter

# 0.12.3 - 2019/02/27

* Weaken webspicy dependency constraint, to prevent clients from upgrading
  to higher versions of finitio.

# 0.12.2 - 2019/01/25

* Expose Resource#location, to let hooks make decisions depending on the
  file in which test cases currently executed are defined.

# 0.12.1 - 2018/10/12

* HttpClient now correctly sends the file name to the tested backend when
  using file uploads.

# 0.12.0 - 2018/08/22

* A service can now define a `default_example` with shared attributes of all
  examples, counterexamples and generated counter exampled. The default example
  is merged with each example before execution (even before instrumentation,
  to be precise). The merge strategy is a deep recursive merge on all hashes
  and a concatenation on arrays. This allows the example/counterexample to
  easily override the default example on specific attributes.

# 0.11.2 - 2018/08/16

* Fixed a `NoSuchMethodError each` on NilClass related to :instrument listeners
  on Config.

# 0.11.1 - 2018/08/16

* Fixed dependency requirements to avoid rubygems warnings.

# 0.11.0 - 2018/08/16

* Webspicy now comes with Precondition and Postcondition modules. They aim at
  being included by actual classes to meet the expected contracts easily.
  Default implementations do nothing.

* Config now supports an `instrument` method, taking an instrumentation block.
  Those blocks are called after before_each and after all pre/post condition
  instrumentations.

* Test cases now support a `metadata` YAML entry, to track domain specific tags
  (typically used in PRE/POST conditions or Config#instrument).

# 0.10.2

* Fixed gem publish date.

# 0.10.1

* Postconditions can optionally instrument a test case before execution too. This
  is handy to clean stuff before running a test case.

# 0.10.0

* Add support for file upload based on multi-part for data and a single parameter.

# 0.9.1

* Fixed assertion messages when an assertion fails. Now the extracted value is shown
  instead of the general web service invocation result.

* Added `includes` and `notIncludes` assertions.

# 0.9.0

* Added `Configuration#before_each` for executing code before each test case execution.

* Added `Configuration#after_each` for executing code after each test case execution.

* Added `Configuration#around_each` to execute a block around each test case execution.

* Added `Configuration#before_all` and `Configuration#after_all` to execute blocks of
  code before and after the whole test suite, respectively

* BREAKING CHANGE (should have no impact, however): `Configuration#before_listeners`
  and `Configuration#after_listeners` are removed. Use `Configuration#listeners`
  instead with the kind of listeners you need.

* BREAKING CHANGE (should have no impact, however): We only keep ONE RSpec `it` block
  for an entire test case, instead of splitting the various post conditions. This was
  necessary for `around_each` to work fine with our test case definition. It also
  yields a correct number of examples = number of test cases.

* Fixed URL instantitation procedure: all URL parameters are now correctly removed
  from sent body.

# 0.8.6

* Weakened finitio version requirement to prevent conflicts on projects using
  Finitio themselves.

# 0.8.5

* Add match and notMatch assertions

# 0.8.4

* Authorize URL parameters to be dotted expression, e.g. `/customers/{customer.id}`,
  that are properly extracted from the input data.

* Upgraded rspec to 3.7. Fixed Tester to load tests on construction, properly resetting
  RSpec global state (!!) first, and running them on call.

# 0.8.3

* Make sure real HTTP requests are not made on normalized URLs, because it makes
  security tests checking that URL hacks are done impossible to write. In particular,
  this means that URLs containing '..' are sent as such to the server.

# 0.8.2

* Add support for OPTIONS verb in rack and http clients

# 0.8.1

* Fix HttpClient failing with a `NoSuchMethodError "to_real_url"`

# 0.8.0

* BREAKING CHANGE: The Proc used as host resolver in the configuration now takes
  two arguments instead of one: the url to resolve, and the current test case under
  execution. This allows the configuration to dynamically adjust the host to use
  on a test-case basis.

# 0.7.0

* BREAKING CHANGE: Precondition#instrument now takes the client as
  first argument. That allows preconditions to make external API calls as part of
  the instrumentation.

* BREAKING CHANGE: Preconditions instrumentation is now called after the before
  handlers, not after them.

# 0.6.0

* Added support for an explicit `body` (yml entry) on POST requests.

# 0.5.0

* The PATCH http method is now supported by webspicy.

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

* BREAKING CHANGE: Preconditions#ensure is renamed as Precondition#instrument.

# 0.4.2

* Fix a bug with path extraction on arrays, e.g. notEmpty('0/foo/1/bar')

# 0.4.1

* Fix a bug when with url placeholder replacement when dressParams is set to false
  while the URL contains placeholders.

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
