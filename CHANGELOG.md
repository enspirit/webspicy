# 0.4.0

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
