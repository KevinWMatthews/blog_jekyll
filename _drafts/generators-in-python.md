---
title: &title "Generators in Python"
permalink: /generators-in-python/
excerpt: "High-level syntax for putting custom classes in a for loop"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - python
tags:
  - python
  - generators
  - iteration
---

If you're already comfortable with generators, look at the
[generator cheat sheet](/python-generator-cheatsheet/). If you need an
introduction to iterators, look at this [iterator](/iterators-in-python/) post.


## Source

Find [source code]()
and [documentation]() on GitHub.


## Background

Generators provide an easy way to give sequential access to each item in a collection.
They are syntactic sugar around iterators and simplify the process considerably.


## Recap of iterators

Here is an example iterable and its iterator from a previous post on  [iterators](/iterators-in-python/):

```python
class Iterable:
    def __init__(self, collection):
        self.collection = collection

    def __iter__(self):
        return Iterator(collection)

class Iterator:
    def __init__(self, collection):
        self.collection = collection
        self.index = 0
        self.max_index = len(collection)

    def __iter__(self):
        return self

    def __next__(self):
        if self.index >= self.max_index:
            raise StopIteration

        item = self.collection[self.index]
        self.index += 1
        return item
```

An iterable class must:
  * implement an `__iter__()` method that returns an iterator

This iterator must:
  * implement an `__iter__()` method that returns itself
  * implement a `__next__()` method that provides sequential access to each item in the collection
  * raise a `StopIteration` exception when the end of the collection is reached

Notice that the iterator must explicitly maintain internal state - it must know where it was
in the collection when `__next__` was most recently called.


## Introduction to generators

Generators simplify the process of creating an iterator - they hide the iterator class entirely and provide easy ways for the iterator to track its current location in the collection.

Generators are created in a surprisingly simple way: using a Python language feature called a [yield expression](https://docs.python.org/3/reference/expressions.html#yieldexpr).
When Python encounters a `yield` expression in a function, it will create
a [generator function](https://docs.python.org/3/glossary.html#term-generator)
instead of a regular function object. Generator functions are special functions - when called, Python automatically creates and returns a [generator iterator](https://docs.python.org/3/glossary.html#term-generator-iterator).

A generator iterator is a specialized iterator. It satisfies the above
requirements of an iterator: it provides each item in the collection and
raises `StopIteration` when it runs out of items. It also provides a few
[methods](https://docs.python.org/3/reference/expressions.html#generator-iterator-methods) that we won't need to discuss here.

Here is some pseudo-ish code for creating an iterable class:

```python
class Iterable:
    def __iter__(self):
        yield # each item in the collection
```

In detail, our previous iterator could be rewritten like this:

```python
class Iterable:
    def __init__(self, collection):
        self.collection = collection

    def __iter__(self):
        index = 0
        max_index = len(self.collection)
        while index < max_index:
            yield self.collection[index]
            index += 1
```

The magic stems from the keyword `yield`.
Python knows that this function will be expected to return a series of values
instead of a single return value, so it creates and returns a generator iterator.
This object automatically:
  * implements an `__iter__()` method that returns itself
  * implements a `__next__()` method that calls the body of our `__iter__()` function
  * raises `StopIteration` when our function reaches the end of its collection

Since `Iterable.__iter__()` returns a valid iterator, we can plug our
`Iterable` class into a `for` statement. The `for` loop can operate on the
generator iterator just like any other iterator:
  * create one using `iter()`
  * retrieve an item in the collection using `next()`
  * catch the `StopIteration` exception


## Generator details

Before looking at the details of how generator iterators work, let's explore the differences between functions and generator functions.


### Generator functions

First let's create a minimal function:

```python
def function():
    return
```

When Python encounters `def` it creates a function object, which we can see by printing the function:

```python
$ python3
>>> def a_function():
...     return
...
>>> print(a_function)
<function a_function at 0x7f22fa747668>
```

or inspecting it:

```python
$ python3
>>> import inspect
>>> test_me = a_function
>>> result = inspect.isfunction(test_me)
>>> print(result)
True
>>> result = inspect.isgeneratorfunction(test_me)
>>> print(result)
False
>>> result = inspect.isgenerator(test_me)
>>> print(result)
False
```

If Python encounters `yield` within a function, it creates a special type of function: a generator function.

```python
$ python3
>>> def a_generator_function():
...     yield
...
```

Printing this shows a function:

```python
>>> print(a_generator_function)
<function a_generator_function at 0x7fe3e60fa7b8>
```

Inspecting this shows that Python creates a special type of function:

```python
>>> import inspect
>>> test_me = a_generator_function
>>> result = inspect.isfunction(test_me)
>>> print(result)
True
>>> result = inspect.isgeneratorfunction(test_me)
>>> print(result)
True
>>> result = inspect.isgenerator(test_me)
>>> print(result)
False
```

Importantly, this generator function is not a generator (iterator) itself.

Functions and generator functions be behave differently when called. Regular functions return a user-specified type - `None` in this case:

```python
$ python3
>>> def a_function():
...     return
...
>>> test_me = a_function()
>>> print(test_me)
None
```

By contrast, generator functions return a generator iterator:
```python
$ python3
>>> def a_generator_function():
...     yield
...
>>> test_me = a_generator_function()
>>> print(test_me)
<generator object a_generator_function at 0x7fe3e6112888>
```

Inspecting this shows that the returned value is a generator iterator object (not a generator function):
```python
>>> import inspect
>>> test_me = a_generator_function()
>>> result = inspect.isfunction(test_me)
>>> print(result)
False
>>> result = inspect.isgeneratorfunction(test_me)
>>> print(result)
False
>>> result = inspect.isgenerator(test_me)
>>> print(result)
True
```


### Generator iterators

When a generator function is called, Python delays executing the body of the function. Instead, it returns a generator (generator iterator) that controls how and when the function is called in the future.

This generator iterator will:
  * implement an `__iter__()` method that returns itself
  * implement a `__next__()` method that actually executes the generator function
  * track the execution state of the generator function between calls to `__next__()`
  * track all local variables in the generator function between calls to `__next__()`
  * raise `StopIteration` automatically when the generator function returns

Generator iterators do a lot of magic behind the scenes but meet all the requirements of iterators.


#### Exploratory generator

Let's create a generator for the purposes of exploring how they work.
It isn't so Pythonic but it will be useful.

```python
$ python3
>>> def a_generator_function():
...     i = 0
...     print("First execution")
...     while True:
...         print("Before yield: {}".format(i))
...         yield
...         i += 1
...         print("After yield: {}".format(i))
...         if i > 2:
...             return
...
```


#### Implement `__iter__()`

A generator implements `__iter__()` and it returns itself:

```python
>>> generator_iterator = a_generator_function()

>>> print(generator_iterator)
<generator object a_generator_function at 0x7f7233de21a8>

>>> test_me = generator_iterator.__iter__()
>>> print(test_me)
<generator object a_generator_function at 0x7f7233de21a8>
```

#### Implement `__next__()`

A generator implements `__next__()`.

```python
$ python3
>>> def a_generator_function():
...     yield
...
>>> generator_iterator = a_generator_function()
>>> test_me = generator_iterator.__next__
>>> print(test_me)
<method-wrapper '__next__' of generator object at 0x7f7233de2200>
```


#### Track execution state

Another key feature of generators is that they
[track execution state](https://docs.python.org/3/reference/expressions.html#generator.__next__)
between calls to `__next__()`.
When a generator reaches a yield expression, it returns an item to the caller but
remembers precisely what it was executing. When `__next__()` is called again,
the generator iterator picks up exactly where it left off.

For example,
```python
>>> iterator = a_generator_function().__iter__()
>>> iterator.__next__()
First execution
Before yield: 0

>>> iterator.__next__()
After yield: 1
Before yield: 1
```

Python executes only up to the `yield` expression in the first call to `__next__()`. On the secondcall to `__next__()`, Python resumes executing just after `yield`.


#### Track local state

Generator iterators [track all local variables](https://docs.python.org/3/reference/expressions.html#generator.__next__)
between calls to `__next__()`.
This makes it easier for a generator to track its location in the collection -
it can simply use local variables.

This is apparent in the previous example and is illustrated further with another call to `__next__()`:

```python
>>> iterator.__next__()
First execution
Before yield: 0

>>> iterator.__next__()
After yield: 1
Before yield: 1

>>> iterator.__next__()
After yield: 2
Before yield: 2
```

The value of `i` is stored between calls.


#### Raise `StopIteration`

When a generator function returns, the generator iterator automatically
raises a `StopIteration` exceptino:

```python
>>> iterator.__next__()
First execution
Before yield: 0

>>> iterator.__next__()
After yield: 1
Before yield: 1

>>> iterator.__next__()
After yield: 2
Before yield: 2

>>> iterator.__next__()
After yield: 3
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
StopIteration
```


#### Simplify generator

These features of generator iterators allow us to simplify the generator function.

For example, our previous iterator class must track state using instance
variables `self.index` and `self.max_index`,

```python
class Iterator:
    def __init__(self, collection):
        self.collection = collection
        self.index = 0
        self.max_index = len(collection)

    def __next__(self):
        if self.index >= self.max_index:
            raise StopIteration

        item = self.collection[self.index]
        self.index += 1
        return item
```

while generators can simply use local variables `index` and `max_index`:

```python
class Iterator:
    def __init__(self, collection):
        self.collection = collection

    def __iter__(self):
        index = 0
        max_index = len(self.collection)
        while index < max_index:
            yield self.collection[index]
            index += 1
```

The fact that all state is maintained allows us to simplify further:

```python
    def __iter__(self):
        for item in self.collection:
            yield item
```

Python knows where it is in the `for` loop, so it can return an item and then
pick up exactly where it left off. In detail, Python will:

  * start executing the `for` loop
  * suspend execution of the loop at the first call to `yield`
    - return an item to the caller
    - store all execution state
  * resume executing the for loop


### Using a generator, in detail

Let's look at the details of what happens when we pass our simplified generator
into a `for` loop:

```python
class Iterable:
    def __init__(self, collection):
        self.collection = collection

    def __iter__(self):
        for item in self.collection:
            yield item

collection = (4, 5, 6)
iterable = Iterable(collection)
for item in iterable:
    print(item)
```

There are two distinct stages: creating an iterator and looping over the collection.

To create an iterator:

  * `for` creates an iterator using `iter()`.
  * `iter()` calls our iterable class's `__iter__()` method, which returns a generator iterator oject

To loop over the collection,

  * `for()` calls `next()` on the generator iterator object
  * `next()` calls the iterator's `__next__()` method
  * `__next__()` executes the generator function (the body of out `__iter__()`) and until it reaches `yield`
  * the generator function returns an item in the collection and suspends execution, allowing the caller (the body of the `for` statement) to execute
  * when the body of the `for` statement finishes executing, it calls `next()` on the iterator again
  * the process repeats until the iterator raises a `StopIteration` exception

To demonstrate some of these steps we can manually loop over the collection:

```python
collection = (4, 5, 6)
iterable = Iterable(collection)

iterator = iterable.__iter__()
while True:
    try:
        item = iterator.__next__()
        print(item)
    except StopIteration:
        break
```


### Using a generator, high-level

Generators are powerful because the developer can ignore indices, exceptions,
`__iter__()`, and `__next__()`. A generator should simply `yield` each item in the collection.
`for` knows what to call to get each item.

Let's revisit the previous example but think of it from a high-level perspective:

```python
class Iterable:
    def __init__(self, collection):
        self.collection = collection

    def __iter__(self):
        for item in self.collection:
            yield item

collection = (4, 5, 6)
iterable = Iterable(collection)
for item in iterable:
    print(item)
```

There are still two distinct stages, but we'll ignore the details:

  * `for` creates an iterator by calling `__iter__()`
  * the iterator `yield`s each item in the collection (using its own `for` loop)
  * the calling `for` loop receives the item and executes the user's code

That's it!


### Further Reading

  * Python3 tutorial: [generators](https://docs.python.org/3/tutorial/classes.html#generators)
  * Python3 reference: [generators](https://docs.python.org/3/glossary.html#term-generator)
  * Python3 reference: [yield statement](https://docs.python.org/3/reference/simple_stmts.html#the-yield-statement)
  * Python3 reference: [yield expressions](https://docs.python.org/3/reference/expressions.html#yield-expressions)
  * Python3 reference: [methods on generator iterators](https://docs.python.org/3/reference/expressions.html#generator-iterator-methods)













  ```
  $ python3
  >>> def a_generator_function():
  ...     yield
  ...
  >>> generator_iterator = a_generator_function()
  >>> members = inspect.getmembers(generator_iterator)
  >>> for member in members:
  ...     print(member)
  ...
  # ...
  ('__iter__', <method-wrapper '__iter__' of generator object at 0x7fe3e42fd200>)
  # ...
  ('__next__', <method-wrapper '__next__' of generator object at 0x7fe3e42fd200>)
  ```
