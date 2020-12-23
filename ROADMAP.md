# Roadmap

A few ideas listed here, from the vision exposed in `doc/`.

## 1.0

* YAML schemas must have a better mapping with vocabulary, in a backward compatible way. It must be easy to migrate an existing specification & test suite.

* Make assertion support more generic: it should be possible to assert the response, not only the output.

* Support jsonpath for assertions paths, instead of hardcoded paths.

* Add support for mutated examples and counterexamples directly in .yml files.

* Add support for state managers and background, to avoid extensively relying on hooks.

* Improve the default Finitio system to have many reusable types with examples and counterexamples.

* Improve commandline with more options and curl mimics.

## Beyond 1.0

* Introduce formal layer where predicates can be used in all conditions and reused accross specifications

* Add support for formal operation names, that could be used in background

* Add support for test case scenarii, where multiple calls can be made sequentially
