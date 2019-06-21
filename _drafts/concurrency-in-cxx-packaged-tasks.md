---
title: &title "Concurrency in C++: Packaged Tasks"
permalink: /concurrency-in-cxx-packaged-tasks/
excerpt: "Using packaged tasks from the standard library"
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

Use a packaged task, a wrapper around a promise, to cleanly return a result from one thread to another.
To learn the underlying language features, see [futures and promises](/concurrency-in-cxx-futures-and-promises/).


## Source

Find [source code](https://github.com/KevinWMatthews/cxx-concurrency) on GitHub.


## Background

Packaged tasks reduce boilerplate involved in setting up futures and promises. Packaged tasks will:
  * create a promise
  * provide access to the promise's future
  * set the promise's value or raise an exception appropriately

As of C++11, [packaged tasks](https://en.cppreference.com/w/cpp/thread/packaged_task) are part of the C++ standard library in the header file `<future>`.


## Syntax


### Futures and Promises

Recall the basic idea behind futures and promises: unidirectional, lock-free, safe information exchange from one thread to another.

  * Create a future/promise pair.
  * Spawn a thread and send it the promise
  * The thread with the promise sends data
  * The thread with the future waits for data

At a high level, futures and promises look something like this:

```c++
#include <future>
#include <thread>

std::promise<int> the_promise;
std::promise<int> the_future { the_promise.get_future() };

std::thread worker_thread { worker_task, std::ref(the_promise) };
worker_thread.detach();

int result = the_future.get()
```

At the next level down,

```c++
void worker_task(std::promise<int>& some_promise)
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

The developer is most interested in the high level (spawning the worker task) and the low level (doing the actual work) but must set up boilerplate in the middle: a `worker_task` with a `try/catch` that will call `set_value()` or `set_exception()` appropriately.

C++'s `packaged_task`s are designed reduce this intermediate code. They hide the intermediate level, which allows the user to focus the high level threads and low level details.


### Create Packaged Task

A `packaged_task` accepts a function directly:

```c++
std:packaged_task<int()> the_ptask { do_actual_work };
```

The type of the packaged task must match the signature of the function that it is passed.

This creates a promise automatically, which the user can get using:

```c++
std::future<int> the_future { the_ptask.get_future() };
```

The type of the future must match the return value of the packaged task's function.

Now that we have a future/promise pair, we can pass the promise into a worker thread as before:

```c++
std::thread worker_thread { std::move(the_ptask) };
```

The packaged task must be moved; it can not be copied.

Notice that we don't define a function that accepts a packaged task!
The packaged task itself is a [callable](https://en.cppreference.com/w/cpp/named_req/Callable) object - it provides an implementation of [operator()](https://en.cppreference.com/w/cpp/thread/packaged_task/operator()) that automagically:

  * Calls the user's function in a try/catch block
  * Calls the promise's `set_value()` on success
  * Calls the promise's `set_exception()` on exception

The parent thread can then wait for a result as usual:

```c++
the_future.get();
```


### Example

A packaged task with no arguments looks something like this:

```c++
#include <future>
#include <thread>

int do_actual_work()
{
    // return or throw
}

std::packaged_task<int()> the_ptask { do_actual_work };
std::future<int> the_future { the_ptask.get_future() };

std::thread worker_thread { std::move(the_ptask) };
worker_thread.detach();

try
{
    int result = the_future.get();
    // Use result
}
catch (...)
{
    // Handle exception
}
```


## Passing Arguments


### Custom Type

If the function for the packaged task requires an argument, the type of the package task gets progressively more complex:

```c++
int do_actual_work(int);
std::packaged_task<int(int)> the_ptask {do_actual_work};
```

It is useful to define a custom type that corresponds to the function's signature:

```c++
int do_actual_work(int);
using Task_type = int(int);
std::packaged_task<Task_type> the_ptask {do_actual_work};
```


### Arguments to Thread

Arguments are automatically passed to the packaged task's callable when the thread is spawned:

```c++
std::thread worker_thread { std::move(the_ptask), 42 };
```


### Example

Here is an example of using a packaged task with an argument:

```c++
int do_actual_work(int)
{
    // return or throw
}

using Task_type = int(int);

std::packaged_task<Task_type> the_ptask { do_actual_work };
std::future<int> the_future = the_ptask.get_future();

int arg = 42;
std::thread worker_thread { std::move(the_ptask), arg };
worker_thread.detach();

try
{
    int result = the_future.get();
    // Use result
}
catch (...)
{
    // Handle exception
}
```


## Further Reading

Docs:

  * [packaged_task](https://en.cppreference.com/w/cpp/thread/packaged_task)
