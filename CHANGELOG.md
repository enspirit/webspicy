## 0.27.3 - 2025-03-28

* Allow `for` attribute in test cases, even in v1 generated from v2.

## 0.27.2 - 2025-03-28

* Improve openapi parameters object, dump attribute descriptions if any

* Instantiate example URLs, via the first test_case filling the service
  parameters.

* The Error schema of counterexamples is not longer checked on redirect
  statuses, since the body is usually empty. This allows no longer moving
  an actual counterexample to the examples section just to prevent Webspicy
  from complaining.

## 0.27.1 - 2025-03-22

* Same as 0.27.0 but docker images fixed.

## 0.27.0 - 2025-03-22

* Possibly BREAKING: docker images are now based on ruby-3.2-alpine.

* Allow using (x) on preconditions.

* Bug fix: keep all instantiable conditions, not only one matching
  condition per description. The bug fix allows using many global
  pre/post conditions matching all tests programatically.

* Introduce some v2 vocabulary: `params` becomes `input`,
  `dress_params` becomes `validate_input`, `for` is available for
  human-readable link with preconditions, `when` and `it` can be
  used as an alternative to `description`. All syntactic changes are
  implemented in a backward compatible way: seen as syntactic sugar
  for now, translated to the former mechanisms for now.

* Added Tester#call_one(TestCase) helper, that can be used by pre/post
  conditions who want to execute a test case they have. Alternative to
  find_and_call.

* Bug fix: validate output schema against the raw output when output
  is not "structured" (e.g. application/json) but pure text
  (e.g. `text/plain`, `text/csv`). Otherwise using String(s | ... ) has
  no effect.

* [Experimental] Add an alternative to openapi Generator to generate openapi
  schema via a reporter when running tests. This allows having great examples
  data, since they are real examples taken from live tests instead of
  being randomly generated from Finitio schemas.

  You can use the reporter like this:

      folder = Path(...)
      config = Webspicy::Configuration.dress(folder)
      config.reporter << Webspicy::Web::Openapi::Reporter.new(
        (folder/'openapi.base.yml').load,
        (folder/'openapi.json'),
      )

## 0.26.0 - 2023-06-23

* Upgrade runtime and devel dependencies, notably http (5.x) and
  sinatra (3.x). This may force client projects to upgrade them as
  well.

## 0.25.0 - 2023-06-09

* BREAKING: GlobalRequestHeaders and RobustToInvalidInput are moved to
  the Webspicy::Web::Specification::Pre module and must be required
  explicitely.

  ```
  require 'webspicy/web/specification/pre/global_request_headers'
  c.postcondition Webspicy::Web::Specification::Pre::GlobalRequestHeaders
  ```

* Possibly BREAKING: upgraded dependencies to properly work with ruby 3.2:

  - predicate to 2.8
    - sexpr to 1.1
  - rack-robustness to 1.2

* Added three reusable postconditions in Webspicy::Web::Specification::Post
  (that must be explicitely required too):

  - LastModifiedCachingProtocol and ETagCachingProtocol that help testing
    that a GET endpoint properly sets the Last-Modified and ETag headers
    and take them into account if the If-Modified-Since and If-None-Match
    request headers are used.

  - SemanticsPreservedByRefactoring that can be used to test that
    refactorings preserve the web semantics.

* Added `eq` and `eql` assertions, that use the Predicate gem.

## 0.24.0 - 2023-05-26

* BREAKING: drop support for ruby < 2.7
* Upgrade finitio to 0.12.x

## 0.23.0 - 2023-02-22

* Upgrade sinatra and musterman to 3.x

## 0.22.0 - 2023-02-11

* Upgrade sinatra and musterman to enable latest security patches
  for sinatra 2.x

## 0.21.7 - 2023-02-08

* Correctly use x-www-form-encoded when documenting POST_FORM
  in openapi generation.

## 0.21.6 - 2023-01-06

* Add support for pre and post conditions to contribute to
  openapi's verb definitions.

## 0.21.5 - 2023-01-06

* A Service now supports an optional name, that is different
  than the description. It is used to distinguish summary
  from description in openapi export.

* OpenAPI Generator now supports a `openapi.base.yml` file next
  to the config.rb file. It is then taken as base information
  for the openapi specification. A deep merge is done, so the
  mechanism allows overriding generated paths.

* OpenAPI Generator now organizes the different paths using
  openapi's tags mechanism. The resource names are taken as
  tags for now.

## 0.21.4 - 2023-01-06

* OpenAPI Generator now supports custom info at call time

## 0.21.3 - 2022-08-03

* Fix a few openapi errors

## 0.21.2 - 2022-07-26

* Fix query params encoding with http_client.

## 0.21.1 - 2022-07-19

* Fix missing custom param_name when using file_upload

## 0.21.0 - 2022-06-21

* Add WATCH=folder1,folder2 option that allows watching files
  rerunning selected tests automatically when those files
  change.

  before_all and after_all handlers are only executed once.

  The -w / --watch option is equivalent to WATCH=.

## 0.20.24 - 2021-12-23

* Remove annoying empty lines when a service has no test ran.

## 0.20.23 - 2021-12-23

* Fix mutability of the default example, yielding false posititve
  test failures.

## 0.20.22 - 2021-12-17

* RackTestClient no longer overrides Content-Type with application/json
  on POST requests.

## 0.20.21 - 2021-12-09

* Let's upgrade finitio to 0.11 so that dashes are allowed as
  attribute names in schema.

## 0.20.20 - 2021-11-25

* Fix email subject handling (Fakesmtp)

## 0.20.19 - 2021-11-23

* Fix removes extra empty lines on output when multiple filter used

## 0.20.18 - 2021-10-27

* Fix failures being not properly reported with FAILFAST=1
* Fix commandline exit code when FAILFAST=1 is used and the test suite fails
* Add basic support for parameters in openapi generation

## 0.20.13 -> 0.20.17

* Improve support for fake mailers

## 0.20.12 - 2021-06-09

* Support YAML files with `.yaml` extension.

## 0.20.11 - 2021-06-04

* Tester::Fakesendgrid is provided to help writing post conditions
  about emails captured using the `ghashange/sendgrid-mock` docker
  image.

## 0.20.10 - 2021-05-05

* Adding gem release to Jennkins pipeline.

## 0.20.9 - 2021-05-01

* Fix tester skipping error summary & documentation reporting after
  successful tests.

* Add a JUnit xml reporter, that can be used in Jenkins to easily navigate
  the test failures.

## 0.20.8 - 2021-04-28

* Fix status code of `webspicy` commandline tool when errors occur (vs.
  failures). The ErrorCount reporter is replaced by SuccessOrNot. The
  former name can still be used for backward compatibility and will
  replaced in 0.21.

## 0.20.7 - 2021-04-21

* Fix Fakesmtp#last_email when more than one email was sent (the first
  one was returned instead of last one)

## 0.20.6 - 2021-04-20

* Add support for reply-to in Fakesmtp::Email.

* Prevent Documentation reporter from showing empty service sections.

## 0.20.5 - 2021-03-15

* Replace `colorize` gem by `paint` to avoid a GPL licence
  issue (`paint` is licensed under MIT).

## 0.20.4 - 2021-03-13

* Add Tester#call! that will abort the current process in case
  of errors. This is the method that should be called in rake
  tasks to make sure the process status properly reflects a test
  suite failure.

* Configuration#reporter is now provided to set the reporter to
  use. It must be a Tester::Reporter instance for now.

* Configuration#colorize is now a boolean flag allowing to enable
  or disable colors in reporter output(s).

* Fix POST/ERR condition checkboxes not working properly.

* Fix POST/ERR condition check raising a failure when the condition
  actually succeeds (following former protocol).

## 0.20.3 - 2021-03-12

* Jenkins now builds and push tagged images,
  e.g enspirit/webspicy:0.20-tester
  and enspirit/webspicy:0.20.3-tester

## 0.20.2 - 2021-03-12

* Improve backward compatibility where possible, to ease
  transition from 0.16.x and 0.17.x

## 0.20.1 - 2021-03-12

* Fixed output schema validation wrongly occuring even when
  application/json is not used as response content-type.

## 0.20.0 - 2021-03-12

* BROKEN: all hooks now take a single `tester` instance instead
  of client and/or scope.

* DEPRECATED: Specification::Pre/Post/Errcondition are deprecated
  but a compatibility bridge is provided and automatically used.

  Please now use Specification::Pre, ::Post and ::Err instead,
  whose `instrument` and `check!` methods take no arguments at
  all (but provide invocation, test_case, config, scope, etc.
  through getters).

* Tester::Fakeses is provided to help writing post conditions
  about emails captured using the `quadrabee/fake-ses` docker
  image.

* Tester::Fakesmtp is provided to help writing post conditions
  about emails captured using the `reachfive/fake-smtp-server`
  docker image.

* Post and Err conditions may now start with a checked box
  `(x) ...`. In such case, webspicy will fail when no post
  condition instrumentation class is provided that matches the
  POST.

  When the checkbox is unchecked `( ) ...` the test will fail
  when instrumentation code is actually provided.

## 0.19.0 - 2021-03-09

* RSpec is no longer used to run the test suite. Webspicy now
  has its own test engine. The aim is to provide test suite
  reporting appearing more natural in a techno-agnotic setting.
  In particular, no stacktrace is shown for errors and failures
  that do not involve user-specific ruby code.

* Improves error messages ; distinguish various stages of
  assertions (web protocol, then and only then output, then and
  only then semantics)

* An --insecure (INSECURE=yes) option is added that mimics curl
  and allows bypassing SSL certifiation verification

* Fix hooks (e.g. before_each) not working properly when using
  configuration folders.

* Add a World abstraction, available at Configuration#world.
  The world is automatically loaded from data files in the
  'world' folder (next to 'support') during Configuration
  construction (just before yielding the instance to the block).
  JSON and YAML files are supported for now. Objects are
  recursively loaded as OpenStruct. The world itself and all
  its objects are mutable on intent.

* The World abstraction also supports .rb files that are Kernel
  evaluated. If the resulting object includes the
  Webspicy::Support::World::Item marker module, it gets the
  webspicy configuration set through `#config=` and available
  under `#config`.

* Fix webspicy commandline when used with a folder (or its config
  file) and not running in the same directory.

* BREAKING: before_all and after_all now take two arguments: the
  scope and client

* Pre/Post/Errcondition now include a `sooner_or_later` helper
  method that will make an active loop until the block returns a
  truthy value and return nil after a certain number of attempts
  (or raise a TimeoutError)

## 0.18.0 - 2021/02/23

* Dependencies upgraded, http >= 4.0 and finitio >= 0.10.0
  in particular. This may break existing projects and is a
  major upgrade towards new webspicy engine not relying on
  rspec.

## 0.17.0 - 2021/01/11

* Output and error are now loaded according to the content-type
  announced in the response, and only if it not announced,
  according to the expected content type.

* Add support for errconditions in Configuration and TestCase.
  Errconditions are postconditions that are met when the test
  item is called while at least on precondition is violated.

## 0.16.3 - 2020/12/18

* Fix RobustToInvalidInput to include empty params as valid
  counterexamples.

## 0.16.2 - 2020/12/18

* Fix simpler schema not working properly

## 0.16.1 - 2020/12/18

* Fix assertion error on response content type

## 0.16.0 - 2020/12/18

* Improve output when LOG_LEVEL is set to DEBUG
* Improve the commandline to be able to test a single url and spec
* Improve readability of test failures
* Add docker images for commandline and tester

This release may introduce integration issues since runtime
dependencies have been bumped.

* Bump `path` to `2.0` runtime dependency
* Bump `finitio` to `0.9` runtime dependency

## 0.15.7 - 2020/06/07

* Add support for HTTP PUT verb, in both real and rack clients.

## 0.15.6 - 2020/06/05

* Fix return code of the webspicy commandline tool.

## 0.15.5 - 2020/05/14

* Fix error message when the status code does not meet the expectation

* Fix TAG=... not working when the tag is part of the default_example.

## 0.15.4 - 2020/05/13

* Expected status may now use expresions like "2xx" or "3xx" to indicate
  that any status within the century range is considered a success. This
  prevents over constraining assertions for web services returning codes
  200 vs. 201, or 301 vs. 302.

* Weaken content_type expectations. The actual response content type
  must start with the expected content type, but may be longer. That
  allows servers to specify an explicit charset without the test failing
  if the expectation does not care about it.

* Added ROBUST=only option to run counterexamples only. This helps
  spliting test executions in two: all examples first, all counterexamples
  too.

## 0.15.3 - 2020/05/05

* Test case now expose a `counterexample?` method with the obvious
  semantics.

* `after_each` now takes the invocation as second block argument.

* The block called in `around_each` now returns the invocation.

* Invocation now exposes the list of assertion errors in `errors` and
  provides as `has_error?` helper.

* `Configuration` allows hooks to be provided as objects:

      c.after_each(any_instance_responding_to_call)

## 0.15.2 - 2020/04/28

* Webspicy no longer checks expected headers and schema when the response
  is expected to be empty (e.g. 204). This yields too many false positive
  since different web servers do not react exactly the same on 204.

## 0.15.1 - 2020/04/28

* Params sent in GET and OPTIONS are correctly converted to String before
  being used. An error is otherwise raised by HTTP#get.

## 0.15.0 - 2020/03/18

* BREAKING: schema.fio now have to `@import finitio/data` explicitly.
  The Finitio default system is no longer started from by default.

* Possibly BREAKING: `path` and `http` dependencies have been weakened to allow
  ruby projects using `webspicy` as gem dependency to use any version without
  having version clashes. At the time of release, this means that those gems
  will probably get as high as 2.0.x and 4.3.x, while 1.3.x and 2.x where
  previously constrained. This might break a few tests unless your own ruby
  project constraint the gems explicitly.

* Enhance LOG_LEVEL=DEBUG with pretty printing and better logging format

* Provide Finitio location when available on a "Missing / Expected attribute"
  errors.

* Add a basic `webspicy` commandline that runs the tester using the same
  environment variables recognized as with existing rake tasks used here and
  there.

* A `enspirit/webspicy` docker image has been pushed to docker hub, that
  expected some tests and config.rb file mounted as a volume in /home/app.
  The image executes the tests by default.

## 0.14.0 - 2020/02/02

* Allow negative RESOURCE filtering, by prefixing the resource match
  by a !. E.g. RESOURCE=!get will execute all resources in files not
  having a 'get' in their name.

* Add TAG filtering: a TAG environment variable can specify a comma separated
  list of tags (e.g. foo,bar) or no-tags (e.g. !foo,!bar) to filter the tests
  to run and/or excluded, respectively. Tags and no-tags can be mixed, in
  which case the semantics is a simple conjunction of positive (resp. negated)
  clauses. A new `tags` entry  in YAML allows tagging test cases themselves.

  The feature can for instance be used to implement the 'only' feature that
  many frameworks have.

## 0.13.0 - 2020/01/21

* Add junit xml output by default.

* Show response status code in DEBUG log level.

* Catch fatal errors when collecting test expectations, to prevent all errors
  from being properly shown in test results.

* Adds an experimental Mocker abstraction that allows running a real API
  mock based on webspicy files.

## 0.12.5 - 2019/07/17

* RackTestClient now converts nil parameters to '' on GET requests. Before
  ruby 2.5.0, nil.dup raises an error and sinatra tries to duplicate param
  values on dispatch!.

## 0.12.4 - 2019/05/31

* Add Date coercer/asserter

## 0.12.3 - 2019/02/27

* Weaken webspicy dependency constraint, to prevent clients from upgrading
  to higher versions of finitio.

## 0.12.2 - 2019/01/25

* Expose Resource#location, to let hooks make decisions depending on the
  file in which test cases currently executed are defined.

## 0.12.1 - 2018/10/12

* HttpClient now correctly sends the file name to the tested backend when
  using file uploads.

## 0.12.0 - 2018/08/22

* A service can now define a `default_example` with shared attributes of all
  examples, counterexamples and generated counter exampled. The default example
  is merged with each example before execution (even before instrumentation,
  to be precise). The merge strategy is a deep recursive merge on all hashes
  and a concatenation on arrays. This allows the example/counterexample to
  easily override the default example on specific attributes.

## 0.11.2 - 2018/08/16

* Fixed a `NoSuchMethodError each` on NilClass related to :instrument listeners
  on Config.

## 0.11.1 - 2018/08/16

* Fixed dependency requirements to avoid rubygems warnings.

## 0.11.0 - 2018/08/16

* Webspicy now comes with Precondition and Postcondition modules. They aim at
  being included by actual classes to meet the expected contracts easily.
  Default implementations do nothing.

* Config now supports an `instrument` method, taking an instrumentation block.
  Those blocks are called after before_each and after all pre/post condition
  instrumentations.

* Test cases now support a `metadata` YAML entry, to track domain specific tags
  (typically used in PRE/POST conditions or Config#instrument).

## 0.10.2

* Fixed gem publish date.

## 0.10.1

* Postconditions can optionally instrument a test case before execution too. This
  is handy to clean stuff before running a test case.

## 0.10.0

* Add support for file upload based on multi-part for data and a single parameter.

## 0.9.1

* Fixed assertion messages when an assertion fails. Now the extracted value is shown
  instead of the general web service invocation result.

* Added `includes` and `notIncludes` assertions.

## 0.9.0

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

## 0.8.6

* Weakened finitio version requirement to prevent conflicts on projects using
  Finitio themselves.

## 0.8.5

* Add match and notMatch assertions

## 0.8.4

* Authorize URL parameters to be dotted expression, e.g. `/customers/{customer.id}`,
  that are properly extracted from the input data.

* Upgraded rspec to 3.7. Fixed Tester to load tests on construction, properly resetting
  RSpec global state (!!) first, and running them on call.

## 0.8.3

* Make sure real HTTP requests are not made on normalized URLs, because it makes
  security tests checking that URL hacks are done impossible to write. In particular,
  this means that URLs containing '..' are sent as such to the server.

## 0.8.2

* Add support for OPTIONS verb in rack and http clients

## 0.8.1

* Fix HttpClient failing with a `NoSuchMethodError "to_real_url"`

## 0.8.0

* BREAKING CHANGE: The Proc used as host resolver in the configuration now takes
  two arguments instead of one: the url to resolve, and the current test case under
  execution. This allows the configuration to dynamically adjust the host to use
  on a test-case basis.

## 0.7.0

* BREAKING CHANGE: Precondition#instrument now takes the client as
  first argument. That allows preconditions to make external API calls as part of
  the instrumentation.

* BREAKING CHANGE: Preconditions instrumentation is now called after the before
  handlers, not after them.

## 0.6.0

* Added support for an explicit `body` (yml entry) on POST requests.

## 0.5.0

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

## 0.4.2

* Fix a bug with path extraction on arrays, e.g. notEmpty('0/foo/1/bar')

## 0.4.1

* Fix a bug when with url placeholder replacement when dressParams is set to false
  while the URL contains placeholders.

## 0.4.0

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

## 0.3.0

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
