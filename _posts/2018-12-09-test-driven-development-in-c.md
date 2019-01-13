---
title: Test Driven Development in C
categories:
  - TDD
tags:
  - c
  - cpputest
  - tdd
  - cmake
  - docker
---

An introduction to testing C code using CppUTest.

Find working source code [on Github](https://github.com/KevinWMatthews/c-cpputest_intro)
or check out [the docs](https://kevinwmatthews.github.io/c-cpputest_intro/).


## CppUTest?

[CppUTest](http://cpputest.github.io/) is a unit testing framework tailored for embedded C applications. It's
written in C++ (hence "Cpp") but requires little working knowledge of that language.

When writing unit tests you will typically create:

  * test applications written using CppUTest
  * libraries of production code

You can then run the test applications and inspect their output. They will fail
loudly if something goes wrong.

CppUTest is design to run unit tests ("U" is for unit). Tests should be short,
exercising one path through the code. If you need to test several things,
write several tests.

Related unit tests are grouped together, and related groups of tests are packaged
in a single executable. Large libraries may have several executables.

## Minimum Test

A very small unit test looks something
[like this](https://github.com/KevinWMatthews/c-cpputest_intro/blob/master/cpputest_intro/tests/test_minimum.cpp):

```cpp
#include "CppUTest/TestHarness.h"

TEST_GROUP(minimum)
{
};

TEST(minimum, this_test_can_fail)
{
    // Uncomment this to see a failing test
    FAIL("Wiring check");
}
```

There are a few elements:

  * Include the CppUTest test framework
  * Create a group of tests (`TEST_GROUP`) called `minimum`
  * Create an individual test (`TEST`) called `this_test_can_fail`

When run, this test produces the output:
```
$ ./bin/test_cpputest_intro
..
/usr/src/cpputest_intro/tests/test_minimum.cpp:10: error: Failure in TEST(minimum, this_test_can_fail)
	Wiring check

.
Errors (1 failures, 3 tests, 3 ran, 2 checks, 0 ignored, 0 filtered out, 0 ms)
```

As you may have guessed, `FAIL()` always produces a failure message. This isn't
so useful in production code, but it is typically used to verify that the test
framework is running correctly.

If you comment out the offending line,
```cpp
TEST(minimum, this_test_can_fail)
{
    // Uncomment this to see a failing test
    // FAIL("Wiring check");
}
```

the test will pass:
```
$ ./bin/test_cpputest_intro
...
OK (3 tests, 3 ran, 1 checks, 0 ignored, 0 filtered out, 0 ms)
```

Notice that there are actually three tests being run. Tests from several modules
(`minimum`, `module`, `memory`) are packaged into a single executable
(`test_cpputest_intro`).


## Module Test

The `minimum` test is useful to learn about the testing framework, but it doesn't
actually test any code. Let's test a module of production code.

A test now looks
[like this](https://github.com/KevinWMatthews/c-cpputest_intro/blob/master/cpputest_intro/tests/test_module.cpp):
```c
extern "C"
{
#include "module.h"
}

#include "CppUTest/TestHarness.h"

TEST_GROUP(module)
{
};

TEST(module, must_be_42)
{
    int input = 42;
    CHECK_TRUE(module_is_42(input));
}
```

The test application links against a library of production code, calls a specific
function, and verifies its output.

Some differences from before:

  * Include production code, `module.h`. Declare it as C code to avoid linker errors!
  * Call production code, `module_is_42()`

All tests pass:
```
$ ./bin/test_cpputest_intro
...
OK (3 tests, 3 ran, 1 checks, 0 ignored, 0 filtered out, 0 ms)
```

To see this function fail, change the `input` value:
```cpp
TEST(module, must_be_42)
{
    int input = 43;
    CHECK_TRUE(module_is_42(input));
}
```

The test now fails:
```
$ ./bin/test_cpputest_intro
.
/usr/src/cpputest_intro/tests/test_module.cpp:15: error: Failure in TEST(module, must_be_42)
	CHECK_TRUE(module_is_42(input)) failed

..
Errors (1 failures, 3 tests, 3 ran, 1 checks, 0 ignored, 0 filtered out, 0 ms)
```

Be sure to let the linker and compiler guide you as you write tests!


## Memory Leak Checks

One of the selling points of CppUTest is that,
[if enabled](https://github.com/KevinWMatthews/c-cpputest_intro/blob/master/cpputest_intro/src/CMakeLists.txt),
it can check unit
tests for memory leaks as they are run.

This function in the
[memory.c](https://github.com/KevinWMatthews/c-cpputest_intro/blob/master/cpputest_intro/src/memory.c)
module leaks memory:
```c
void memory_leak(size_t buffer_size)
{
    void *leak_me = malloc(buffer_size);
}
```

To see the output of the memory leak checker, uncomment the call to this
function in
[the tests](https://github.com/KevinWMatthews/c-cpputest_intro/blob/master/cpputest_intro/tests/test_memory.cpp):
```cpp
TEST(memory, catches_memory_leak)
{
    // Uncomment this to see a memory leak
    memory_leak(12);
}
```
and run the tests:
```
$ ./bin/test_cpputest_intro

/usr/src/cpputest_intro/tests/test_memory.cpp:12: error: Failure in TEST(memory, catches_memory_leak)
	Memory leak(s) found.
Alloc num (4) Leak size: 12 Allocated at: /usr/src/cpputest_intro/src/memory.c and line: 5. Type: "malloc"
	Memory: <0x251d020> Content:
    0000: 00 00 00 00 00 00 00 00  65 72 50 6c             |........erPl|
Total number of leaks:  1
NOTE:
	Memory leak reports about malloc and free can be caused by allocating using the cpputest version of malloc,
	but deallocate using the standard free.
	If this is the case, check whether your malloc/free replacements are working (#define malloc cpputest_malloc etc).


...
Errors (1 failures, 3 tests, 3 ran, 1 checks, 0 ignored, 0 filtered out, 0 ms
```

The output tells you that:

  * How much memory was leaked: `Leak size: 12`
  * Where it was created: `cpputest_intro/src/memory.c and line: 5.`
  * The contents of this memory (here uninitialized)

Quick feedback!


## References

  * The book [Test Driven Development for Embedded C](https://pragprog.com/book/jgade/test-driven-development-for-embedded-c) is
  an excellent starting point
