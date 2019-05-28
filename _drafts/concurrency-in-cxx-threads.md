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


## Syntax


### Functions

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

What about detaching?


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


## Constructor (TODO title)

### Function Objects

Threads can be passed function objects:

```c++
struct FunctionObject
{
  void operator()();
}

// Create a function object
std::thread a_thread { FunctionObject() };
a_thread.join();
```

The function object is created using the constructor: `FunctionObject()`.
This is passed into the thread, which then calls the `()` operator on the
function object.


### Classes

Threads can be passed callable (?) classes:
```c++
class CallableClass
{
public:
  void operator()();
};

std::thread a_thread { CallableClass() };
```

Note that the `()` must be explicitly made public.


### Lambdas

```c++
auto a_lambda = [](){};
std::thread a_thread { a_lambda };
a_thread.join();
```


```c++
std::thread a_thread { [](){} };
a_thread.join();
```
