---
title: &title "Concurrency in C++: Thread Syntax"
permalink: /concurrency-in-cxx-std-thread-syntax/
excerpt: "Using threads from the standard library"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - cxx
tags:
  - cxx-concurrency
  - cxx
  - concurrency
  - threads
---

This is a reference for the basic syntax of threads in C++.
It assumes an understanding of (POSIX) threads and a modern C++ compiler.


## Source

Find [source code](https://github.com/KevinWMatthews/cxx-concurrency) on GitHub.


## Background

C++ largely predates multi-threaded systems.
Thread support was added to the standard library in C++11.
Refinements and more features were added in C++14 and C++17.


## Syntax

All examples require the standard library header `<thread>`.


### No Arguments

Initialize a thread with the function that should run in a thread:

```c++
void function()
{
    // Do stuff.
}

std::thread a_thread { function };
a_thread.join();
// Alternatively,
// a_thread.detach();
```

Be sure to `detach()` so that the primary thread can continue to run or `join()` so that the primary thread does not exit immediately.


### Single Argument

Pass arguments to a thread by appending to the initializer list:

```c++
void function(int value)
{
    // Do stuff.
}

std::thread a_thread { function, 42 };
a_thread.join();
```

The standard library will pass the value from the initializer list into the function.


### Multiple Arguments

Pass multiple arguments by extending the initializer list:

```c++
void function(int value1, int value2)
{
    // Do stuff.
}

std::thread a_thread { function, 42, 43 };
a_thread.join();
```

The function receives the arguments in the order that they were passed.


### Reference Arguments

To pass an argument as a reference, you must explicitly use [std::ref](https://en.cppreference.com/w/cpp/utility/functional/ref):

```c++
void function(int& value)
{
    // Do stuff.
}

int param = 42;
std::thread a_thread { function, std::ref(param) };
a_thread.join();
```

This is also true for classes.


## Function as a Callable Object

C++ threads simply require a that their first argument is a
[callable](https://en.cppreference.com/w/cpp/named_req/Callable) object.
This can be a function, a function object, struct,
class, lambda, etc.


### Functions

See [above](#syntax).


### Struct

Structs can be used to make a callable object, which can be passed to a thread:

```c++
struct FunctionObject
{
    void operator()();
};

// Create a function object
std::thread a_thread { FunctionObject() };
a_thread.join();
```

Note that the function object must be created using its constructor: `FunctionObject()`.
The thread can then call the `()` operator on the function object.


### Classes

Classes can be used to make a callable object, which can be passed to a thread:

```c++
class CallableClass
{
public:
    void operator()();
};

std::thread a_thread { CallableClass() };
```

As with function objects, the class must be instantiated using its constructur:
`CallableClass()`. The thread can then call the `()` operator.
Note that the `()` operator must be explicitly made public.


### Lambdas

Lambdas can be passed to a thread:

```c++
auto a_lambda = [](){};
std::thread a_thread { a_lambda };
a_thread.join();
```

The thread executes the lambda using `()`.

Lambdas can be passed directly into a thread:

```c++
std::thread a_thread { [](){} };
a_thread.join();
```


### Function Objects

[Function objects](https://en.cppreference.com/w/cpp/utility/functional) can be passed to a thread:

```c++
void function()
{
    // Do stuff.
}

std::function<void()> callable_object {function};
std::thread a_thread { callable_object };
a_thread.join();
```


## Further reading

Links to formal documentation:
  * [std::thread](https://en.cppreference.com/w/cpp/thread/thread)
  * [std::thread constructor](https://en.cppreference.com/w/cpp/thread/thread/thread)
