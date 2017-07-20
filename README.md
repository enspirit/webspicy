# Webspicy

A description, specification and test framework for web services seen as black
box software operations.

## Features

* Declarative description of RESTful web-services + their tests

* Framework/language agnostic: Webspicy is written in Ruby, but can be used to
  test web services in any language / framework.

* Black box testing: Webspicy focuses on web services seen as blackboxes. It has
  no knowledge of the implementation, and focuses on HTTP and input/output data
  instead. Investing in such testing makes those tests stables and your API better.

* Extra goodness for Rubyists: being written in ruby, Webspicy also supports
  testing Rack applications directly (through rack/test)

## Getting started

Please have a look at the example first. It contains a simple Sinatra application
with GET and POST restful services tested with the framework. The Rakefile contains
the necessary tasks to run those tests.
