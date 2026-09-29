# Roadmap

A few ideas listed here, from the vision exposed in `doc/`.

1.0 is out. It does not mark the completion of the feature list that used to
be gathered under that heading below, but the point where the public API is
declared stable and semantic versioning starts being followed strictly. The
gem had been in production use for years by then, and the 0.x prefix was
saying the opposite. Those features are now 1.x material, and will land in
minor releases.

## 1.x

* YAML schemas must have a better mapping with vocabulary, in a backward compatible way. It must be easy to migrate an existing specification & test suite.

* Make assertion support more generic: it should be possible to assert the response, not only the output.

* Support jsonpath for assertions paths, instead of hardcoded paths.

* Add support for mutated examples and counterexamples directly in .yml files.

* Add support for state managers and background, to avoid extensively relying on hooks.

* Improve the default Finitio system to have many reusable types with examples and counterexamples.

* Improve commandline with more options and curl mimics.

## Beyond 1.x

* Introduce formal layer where predicates can be used in all conditions and reused accross specifications

* Add support for formal operation names, that could be used in background

* Add support for test case scenarii, where multiple calls can be made sequentially
