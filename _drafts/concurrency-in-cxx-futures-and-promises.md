---
title: &title "Concurrency in C++: Futures and Promises"
permalink: /concurrency-in-cxx-futures-and-promises
excerpt: "Part 2: Using Futures and Promises From the Standard Library"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - cxx
tags:
  - cxx
  - concurrency
  - futures
  - promises
  - threads
---

## Source

TODO point to example on GitHub.


## Background

As of C++11, futures and promises are part of the C++ standard library.
TODO are all features present?
Header file `<future>`.


## Syntax

The idea is to have the system handle the details of locking.

Create a pair of objects:
  * promise
  * future

The two objects are intertwined. The promise knows how to send information
to the future, and the future knows how to wait for the promise to send data.
"The system" knows how to transfer information safely between the two,
so the user does not need to explicitly lock shared resources.

Consider this case: one thread needs to wait for data from another thread.
The parent thread spawns a child thread and passes the child thread a promise.
The parent thread keeps ownership of the future and uses it to wait for data
from the child's promise.

The child thread, meanwhile, prepares its data (or fails). It then uses its
promise to send either data or an exception back to the parent thread.

```c++
#include <future>
#include <thread>

std::promise<int> the_promise;
std::future<int> the_future = the_promise.get_future();

std::thread child_thread { function, std::ref(the_future) };
```

The child thread executes a `function`. This function *must* accept a reference
to a future of the correct type:
```c++
void function(std::future<int>& some_future)
{
}
```

The function the either sends an exception or a value using the promise:
```c++
void function(std::future<int>& some_future)
{
  try
  {
    int result = do_actual_work();    // This could raise an exception!
    some_promise.set_value(result);
  }
  catch (...)
  {
    // Send the current exception
    some_promise.set_exception(std::current_exception());
  }
}
```

The developer is most interested in the function `do_actual_work()`.
This could do anything, hopefully returning data but possibly raising an exception.
For example,
```c++
int do_actual_work()
{
  // throw "Make the promise fail";
  return 42;
}
```

The parent thread must be sure to wait for data from the child thread:
```c++
std::promise<int> the_promise;
std::future<int> the_future = the_promise.get_future();

std::thread child_thread { function, std::ref(the_future) };
int result = child_thread.get();

// Required if the parent thread is in main - don't exit early!
// child_thread.join();
```

### Doer and Getter Threads

Of course, the main thread isn't always directly waiting for data - sometimes
it spawns multiple workers that need to communicate with each other. The syntax
is similar but now one child task (getter) is waiting for another child task (doer):

```c++
#include <future>
#include <thread>

// Create future/promise pair
std::promise<int> the_promise;
std::future<int> the_future = the_promise.get_future();

// Pass promise to doer thread
std::thread doer_thread { doer_function, std::ref(the_promise) };
// Pass future to getter thread
std::thread getter_thread { getter_function, std::ref(the_future) };

// Don't exit prematurely!
doer_thread.join();
getter_thread.join();
```

The `doer_function` must accept a reference to a promise as an argument and it
is expected to set a value or an exception using its promise:

```c++
int do_actual_work()
{
  // throw "Make the promise fail";
  return 42;
}

void doer_function(std::promise<int>& some_promise)
{
  try
  {
    int result = do_actual_work();    // This could raise an exception!
    some_promise.set_value(result);
  }
  catch (...)
  {
    // Send the current exception
    some_promise.set_exception(std::current_exception());
  }
}
```

Similarly, the `getter_function` must accept a reference to a future as an
argument and it is expected to wait for a value from the promise:
```c++
void getter_function(std::future<int>& some_future)
{
  // The promise could send an exception to the future.
  // Catch it if required.
  try
  {
    int value = some_future.get();
  }
  catch (...)
  {
    // Do stuff
  }
}
```


## TODO

Why refs? why `std::ref` instead of `&promise`?
