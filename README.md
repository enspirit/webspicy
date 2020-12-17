# Webspicy

A specification and test framework for web services seen as black-box software
operations. Because too many backends seem broken.

## Features

* Declarative specification of HTTP web services + their tests

* Framework/language agnostic: `webspicy` is written in Ruby, but can be used
  to test web services for backends written in any language / framework.

* Black box testing: `webspicy` focuses on web services seen as blackboxes. It
  has no knowledge of the implementation, and focuses on HTTP and input/output
  data instead. Investing in such testing makes those tests more stable and
  your API design better.

* Test instrumentation and generation, based on declarative PRE & POST
  contracts.

* Extra goodness for Rubyists: being written in ruby, `webspicy` also supports
  testing Rack applications directly (through rack/test), which boosts the
  test suite.

* Extra goodies: when a specification is written, it can also be used for
  mocking the API, generating an openapi file, etc.

## Getting started with the commandline

The easiest way to learn webspicy basics is the tutorial hosted at
https://yourbackendisbroken.dev.

To install webspicy on your developer computer, install ruby then:

```
gem install webspicy
```

Then execute webspicy help to see the options.

```
webspicy --help
```

## Using the docker image(s)

If you just want to play with the commandline tool without having to
install ruby & webspicy, you can use the docker image we provide for
the commandline:

```
docker run enspirit/webspicy --help
```

If you have a specification & test suite somewhere, an easy way to run the
whole suite (or integrate it in your continuous integration pipeline) is
to use our `-tester` docker image. Just mount your test suite as a volume
in `/home/app` and you are good to go:

```
docker run -v path/to/tests:/home/app enspirit/webspicy:tester
```
