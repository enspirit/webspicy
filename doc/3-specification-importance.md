# On the importance of the specification

Modern software development methods and frameworks, especially Test-Driven (TDD) and Behavior-Driven Development (BDD), use tests extensively. As their name suggests, they use tests to *drive* the development. In fact, it is a major contribution of Agile methods to software development: driving the development by tests invites the developer to improve his code through testing and thereby also improves test coverage as a side effect of the development itself.

However this is not the traditional objective of software testing, which is to test the implementation's conformance to a specification. This yields strange situations where a lot of tests are written while the specification is not:

* Most of the time the specification is implicit: it is simply not written at all,
* Sometimes the specification is written as informal comments on the tested method or class,
* Some test frameworks even suggest that the set of tests *is* the specification, which is notably wrong.

## What is a specification?

As a reminder, a `Specification` is the set of `PRE-`, `POST-` and `ERR-` `conditions` defining the contract between the test item (e.g. a web service) and its consumer. In short,

- if the consumer calls the service while the `PRE` are met, then the service guarantees that the `POST` are met.
- if the consumer calls the service while a `PRE` is not met, and the service is robust, then it guarantees that the `ERR` are met.

## Advantages of an explicit specification

Having a explicit specification has traditional advantages:

- It documents the software, generally in a better and more consise way than a full test suite
- It enables reasoning about correctness: if you don't know the contractual conditions you can't actually know whether the test suite passes by chance of because the software implementation is correct

Beyond those, specifications can also be used somewhat "against the grain", in the test item / specification / test-case triangle. This is the reason why `webspicy` exists, as we want to explore the following advantages in the specific context of API testing:

- A specification can be used to make tests easier to write
  * by instrumenting positive test cases so that preconditions are met with almost no effort from the tester
  * by generating current system states automatically, instead of having to script them

- A specification can be used to generate test cases automatically
  * generating examples aims at testing correctness
  * generating counterexamples aims at testing robustness & security

- A specification can be used as a roadmap
  * documenting unchecked preconditions highlights robustness weakenesses and calls for counterexamples
  * documenting unmet postconditions highlights bugs and call for examples

- A specification may capture best practices and conventions
  * Pre and post-conditions can sometimes be reused across different softwares, when they apply to conventions such as RESTful APIs

