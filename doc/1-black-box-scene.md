# Setting the black-box scene

This document sets the black-box testing & specification scene. We start with the testing vocabulary (that is probably well known) and gradually introduce specification concepts (that are a bit less).

## Test object

The `Test object` is the software under test, generally a backend component exposing web services. As `webspicy` is also used for documentation & specification, we sometimes call it the `Specification object` or `Documentation object`.

The test object is seen as a black-box: its specification and testing are in terms of observable behavior, not driven by the internal structure or implementation.

## Test item

A `Test item` (resp. `Specification item`) is an individual element to be tested (resp. specified). `webspicy` is generally used to test web services invoked thanks to HTTP. If we abstract from HTTP details - and see it as the request/response invocation protocol only - test items are high-level software operations called with input/output data.

## Test case

A `Test case` is a complete setting for invoking a test item, together with assertions on the result. The setting includes a `Current system state` and a `Request` (that contains `Input` data). The result covers the `Resulting system state`, and a `Response` (that contains `Output` data).

## Test suite

A `Test suite` of an object is the set of all its test cases.

## System state

Most of the time we are interested in (deterministic) *stateful* testing. That is, we consider that the behavior of a test item is not only influenced by the `Input` data but also by the current system state.

The `System state` covers the content of all stateful components the test object interacts with in its environment: files, databases, caches, buses, etc.

For effective testing, one needs to be able to control and check the system state easily.

## Current system state

A `Current system state` is the state of the system just before invoking a test item.

## Resulting system state

A `Resulting system state` is the state of the system just after invoking a test item from an current state.

## Request

A `Request` is what is sent to a test object to invoke a test item. When test items are web services, it is a HTTP request specifically.

## Response

A `Response` is what is received from the test object in return from a test item invocation request. When test items are web services, it is a HTTP response specifically.

## Input

The `Input` is the data on which a high-level operation is executed. In a similar way that a high-level operation abstracts from web services details, the input abstracts from HTTP request details.

## Output

The `Output` is the data returned by a high-level operation after execution. In a similar way that a high-level operation abstracts from web services details, the output abstracts from HTTP response details.

## Precondition

A `Precondition` is a necessary condition to be met for the test item to execute successfully when invoked. A precondition can refer to the current state, the request, and/or the input.

The set of preconditions of an item is sometimes written `PRE`.

## Postcondition

A `Postcondition` is a condition that is guaranteed by the test item (if implemented correctly) when invoked while its preconditions holds. A postcondition can refer to the current state (before execution), the request,  the input, the resulting state, the response, and/or the output.

## Input schema

The `Input schema` is a formal definition of the set of valid input data of a test item (hence the underlying high-level operation). The input schema is a `webspicy` formal shortcut for a precondition stating that "input data must be valid, that is ...".

(The input schema can also be seen as the signature of the high-level operation.)

## Output schema

The `Output schema` is a formal definition of the set of possible output data of a test item (idem). The output schema is a `webspicy` formal shortcut for a postcondition stating that "output data is valid, that is ...".

(The output schema can also be seen as the return type of the high-level operation.)

## Ideal specification

An `Ideal specification` is a formal identification of an item, together with the set of its pre and post conditions. By nature the ideal specification covers the input and output schema.

## Example

An `Example` is a positive test case. That is, it is the description of an invocation setting that meets all preconditions of a test item together with assertions on the successful result.

## Counterexample

A `Counterexample` is a negative test case. That is, it is the description of an invocation setting that violates at least one precondition, together with assertions on the error result.

## Errcondition

An `Errcondition` is a condition that is guaranteed by the test item (if implemented correctly) when invoked while at least one precondition is violated. An errcondition can refer to the current state (before execution), the request, the input, the resulting state, the response, and/or the output.

An item is said to be robust when it has strong errconditions: it guarantees some behavior and results even in case of execution failures.

## Error schema

The `Error schema` is a formal definition of the set of possible output data of a test item when it fails to execute successfully, typically because a precondition is violated. The error schema is a `webspicy` formal shortcut for an errcondition stating that "error data must be valid, that is ...".

## Exceptional specification

An `Exceptional specification` is a formal identification of an item, together with the set of its pre and err conditions. By nature the exceptional specification covers the input and err schema.

## Item specification

An `Item specification` is the set of its ideal and exception specications. Therefore it includes all schema, pre, post and err conditions.

## Specification

A `Specification` of an object is the set of all its item specifications.
