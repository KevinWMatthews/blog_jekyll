---
title: &title "Concurrency in C++: Threads"
permalink: /concurrency-in-cxx-std-thread/
excerpt: "Part 1: Using Threads From the Standard Library"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - cxx
tags:
  - cxx
  - concurrency
  - threads
---

## Source

TODO point to example on GitHub.


## Background

As of C++11, threads are part of the C++ standard library.
This post assumes a basic understanding of (POSIX) threads.


## Syntax


### Basic

Initialize a thread with the function that it will call:

```c++
#include <thread>

void function()
{
    // Do stuff.
}

std::thread a_thread { function };
a_thread.join();
```

Be sure to join so that the primary thread does not execute immediately.


### Passing Arguments

Pass arguments to a thread in an initializer list:
```c++
void function(int value)
{
    // Do stuff.
}

std::thread a_thread { function, 42 };
a_thread.join();
```


### Multiple Arguments

?
Arguments are a `...` list


### Reference Arguments

References must be wrapped in [std::ref](https://en.cppreference.com/w/cpp/utility/functional/ref).


## Function is a Callable Object

C++ threads simply require a that the function they are passed is a
[callable](https://en.cppreference.com/w/cpp/named_req/Callable) object.
This can be a function, a function object, struct,
class, lambda, etc.


### Function Objects

[docs](https://en.cppreference.com/w/cpp/utility/functional)


### Struct

TODO change this to a struct
Function objects can be passed to a thread:

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

Classes can be passed to a thread:

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
