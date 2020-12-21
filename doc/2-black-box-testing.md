# Black-box testing

We define here what we call `black-box testing`, using the vocabulary installed previously.

## Objective

Black-box testing aims at checking whether a test object (actually its implementation) meets its specification. It does so by looking at the object's observable behavior only.

## Method

Testing is never exhaustive and gives no correctness guarantees. As one says, testing can only show the presence of defects, not their absence.

In practice, black-box testing meets its objective by checking whether:

* all positive test cases (i.e. examples) yield successful executions meeting the postconditions.

* all negative test cases (i.e. counterexamples) yield unsuccessful executions meeting the errconditions.

## Prerequisites

Applying black-box testing to web services requires at least:

* A test item: a web service endpoint
* A specification: pre, post and err conditions of the web service
* Test cases: examples and counterexamples of web service usage

The second element, i.e. the *specification*, is both important and useful. Modern test frameworks leave the specification implicit (not written at all) or informal (written as code documentation). We think this is both a mistake and a lost opportunity. We will explain why in next section.
