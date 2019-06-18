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

Find [source code](https://github.com/KevinWMatthews/cxx-concurrency) on GitHub.


## Background

As of C++11, futures and promises are part of the C++ standard library.
TODO are all features present?
Header file `<future>`.

Futures and promises provide unidirectional, one-time, lock-free information exchange from one thread to another.
The developer can focus on the information that will be shared and can trust that the system will transfer the data safely.

Information is shared using a pair of objects:
  * promise
  * future

The two objects are intertwined. The promise knows how to send information to the future, and the future knows how to receive data from the promise. If the promise hasn't sent data, the future will wait. If the future isn't ready to receive data, the promise will wait, ensuring that data is sent.
"The system" knows how to transfer information safely between the two *even across threads*.

A promise is meant to be used only once. Each promise is associated with a single future, but it is possible to create a [shared_future](https://en.cppreference.com/w/cpp/thread/shared_future) using [share()](https://en.cppreference.com/w/cpp/thread/future/share).


## Syntax

Let's consider a specific case: a parent thread wants to perform an expensive operation without immediately blocking.
One solution is for the parent to spawn a worker thread and check for a response later.

Futures and promises allow this to be done safely. As the parent thread spawns a worker thread, it passes the worker thread a promise.
The parent thread keeps ownership of the future and uses it to wait for data from the worker's promise.
The worker thread takes ownership of the promise and uses it to send data (or an excpetion) back to the parent's future.

Here is an example of creating a promise:


### Create promise

```c++
#include <future>

std::promise<int> the_promise;
```

The promise wraps a specific data type, in this case an `int`.


### Create future

A future is associated with a specific promise:

```c++
std::promise<int> the_promise;
std::future<int> the_future = the_promise.get_future();
```


### Spawn worker with promise

The parent thread can then spawn a worker thread and send it the promise:

```c++
std::thread worker_thread { worker_task, std::ref(the_promise) };
```

The worker thread has ownership of the promise; the parent thread should no longer access it.

The worker thread, of course, must accept a reference to a promise of the correct type:

```c++
void worker_task(std::promise<int>& a_promise)
{
    // Do work
    // Send result to future
}
```

After finishing its work, the worker task either sends a value or an exception back to the parent thread. This can be done safely using the promise:

```c++
void worker_task(std::promise<int>& a_promise)
{
    try
    {
        int result = do_actual_work();  // Could fail!
        a_promise.set_value(result);
    }
    catch (...)
    {
        some_promise.set_exception(std::current_exception());
    }
}
```

The developer is most interested in the function `do_actual_work()`.
This could do anything, hopefully returning data but possibly raising an exception.
For example:

```c++
int do_actual_work()
{
    // throw "Make the promise fail";
    return 42;
}
```


### Receive result using future

The parent thread must be sure to wait for data from the worker thread.
There are [several options](http://www.cplusplus.com/reference/future/future/) available for this, the simplest of which is [future::get](http://www.cplusplus.com/reference/future/future/get/):

```c++
int result = child_thread.get();
```

The call to `get()` blocks until it receives data from the promise.

The parent thread likely will need to handle exceptions from the promise:

```c++
int result;
try
{
    result = child_thread.get();
}
catch (...)
{
    // Handle exception
}
// Use result
```


## Caveats

TODO verify this!

Be *sure* to use the correct types! Compilers does not seem to throw an error or warning if incorrect types are passed to a promise or future.

For example, setting the value of a promise from a mismatched type can yield an unexpected result without warning:

```c++
float do_actual_work()
{
    return 12.34;
}

void worker_task(std::promise<int>& a_promise)
{
    float result = do_actual_work();
    a_promise.set_value(result);
}
```

This will truncate the result.

Similarly, storing the result of a future in the wrong type does not give a warning:

```c++
std::promise<float> the_promise;
std::future<float> the_future {the_promise.get_future()};

// Spawn worker thread
int result = the_future.get();
```

This also results in truncation.


## Further Reading

Links to formal docs:

  * [\<future\>](http://www.cplusplus.com/reference/future/)
  * [std::future](http://www.cplusplus.com/reference/future/future/)
  * [std::promise](http://www.cplusplus.com/reference/future/promise/)
  * [std::shared_future](http://www.cplusplus.com/reference/future/shared_future/)


## TODO

Why refs? why `std::ref` instead of `&promise`?

  * [read this](https://stackoverflow.com/questions/45626919/stdpromise-set-value-and-thread-safety)
