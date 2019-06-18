---
title: &title "Concurrency in C++: Packaged Tasks"
permalink: /concurrency-in-cxx-packages-tasks
excerpt: "Part 2: Using Packaged Tasks From the Standard Library"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - cxx
tags:
  - cxx
  - concurrency
  - packaged-tasks
  - futures
  - promises
  - threads
---

## Source

Find [source code](https://github.com/KevinWMatthews/cxx-concurrency) on GitHub.


## Background

As of C++11, packaged tasks are part of the C++ standard library.
TODO I think? Are all features present?
Header file `<future>`.

Packaged tasks reduce boilerplate involved in setting up futures and promises.

## Syntax

Recall the basic idea behind futures and promises: unidirectional, lock-free
information exchange from one thread to another.

  * Create a future/promise pair.
  * Send a promise to one thread, the future to the other.
  * The thread with the future waits for data
  * The thread with the promise sends data

At a high level, it looks something like this:
```c++
#include <future>
#include <thread>

std::promise<int> the_promise;
std::promise<int> the_future { the_promise.get_future() };

std::thread doer_thread { function_accepting_promise, std::ref(the_promise) };
int result = the_future.get()

doer_thread.join();
```

At the next level down,
```c++
void function_accepting_promise(std::promise<int>& some_promise)
{
  try
  {
    int result = do_actual_work();
    some_promise.set_value();
  }
  catch (...)
  {
    some_promise.set_exception(std::current_exception());
  }
}
```

And another level down:
```c++
int do_actual_work()
{
  // throw or return value
}
```

The developer is most interested in the high level and the low level but must
be sure to set up the `function_accepting_promise()` layer appropriately.

This is what C++'s `packaged_task`s are used for: to reduce intermediate code.
It allows the user to see the high level and the low level at once.

A `packaged_task` accepts a function directly:
```c++
std:packaged_task<type_goes_here> packaged_task { do_actual_work };
```

It then effectively:
  * Creates a thread that accepts a reference to a promise and the user's function
  * Passes it the promise, and the user's function
  * Calls the user's function in a try/catch block
  * Calls the promise's `set_value()` on success
  * Calls the promise's `set_exception()` on exception
Of course, the actual implementation may vary; this is what the user no longer
has to do manually.

It looks something like this:

```c++
#include <future>

int do_actual_work()
{
  // return or throw
}

// Type must match the user's function above
std::packaged_task<int()> the_ptask { do_actual_work };
std::future<int> the_future { the_ptask.get_future() };

// Move, don't copy
std::thread child_thread { std::move(the_ptask) };
int result = the_future.get();

child_thread.join();
```

Notice that the packaged task makes its corresponding future available with
`get_future()`.
Packaged tasks can not be copied; move it into the thread.
TODO why? They contain resources that can not be duplicated.


This can be simplified slightly:
```c++
int do_actual_work()
{
  // ...
}

// Matches the function signature above
using Task_type = int();

std::packaged_task<Task_type> the_ptask { do_actual_work };
auto the_future { the_ptask.get_future() };

std::thread child_thread { std::move(the_ptask) };
auto result = the_future.get();

child_thread.join();
```

Of course, one can use the namespace `std` to simplify further.
