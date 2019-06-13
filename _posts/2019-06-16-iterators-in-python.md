---
title: &title "Iterators in Python"
permalink: /iterators-in-python/
excerpt: "Basic Python concepts for putting custom classes in a for loop"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - python
tags:
  - python
  - iterators
  - iteration
---

How to create classes that can be plugged into a `for` loop.

If you are already comfortable with iterators, look ahead to the
[generators](/generators-in-python/) post or the
[generator cheat sheet](/python-generator-cheatsheet/).


## Source

Find [source code](https://github.com/KevinWMatthews/python-iterators) on GitHub.


## Background

Iterators are the way that Python allows a `for` loop to traverse
collections and classes. They the details of iteration to be encapsulated in a
class. Python provides specific guidelines for how to do this, the
[iterator type](https://docs.python.org/3/library/stdtypes.html#iterator-types),
which we will explore below.


## Iterator Mechanics

To gain a detailed understading of how iterators work in Python, let's first
naively loop over a collection and then progressively introduce Python syntax to
make the process easier and safer.


### Manually loop over collection

Let's say that we have a collection that is stored in a class:

```python
class Iterable:
    def __init__(self, collection):
        self.collection = collection
```

We would like to loop over this collection and execute some function on each item:

```python
collection = # user creates collection
iterable = Iterable(collection)

# loop over collection
index = 0
max_index = len(iterable.collection)

while index < max_index:
    item = iterable.collection[index]
    index += 1
    # user adds code here
```

This is effective but error-prone. It requries specific knowledge of the class:
how to create the class, where the collection is stored, how to access
individual items in the collection, where in the collection to start looping,
and when to finish looping. Further, the user must add their code in the
middle of the loop - not so clear to read.


### Iterator protocol

To isolate the user from these details, we can create a class that does iteration
for us. Python defines a specific protocol for this; an iterator must implement:

  * `__iter__()` that returns itself
  * `__next__()` (Python2 requires `next()`) that
    - returns the next item from the collection
    - raises `StopIteration` when the end of the collection is reached

A sketch of this looks like:

```python
class Iterator:
    def __init__(self):
        # store collection
        # store current location in collection

    def __iter__(self):
        return self

    def __next__(self):
        # if reached end of collection, raise StopIteration
        # else return current item and
        # move to next location in collection
```

We will examine the `__next__()` method now and return to `__iter__()`
[in a later section](/iterators-in-python/#iterators-must-be-iterable).


### Retrieve or raise using `__next__()`

Let's extract our manual loop into a separate class and add a `__next__()` method:

```python
class Iterable:
    def __init__(self, collection):
        self.collection = collection

class Iterator:
    def __init__(self, collection):
        self.collection = collection
        self.index = 0
        self.max_index = len(collection)

    def __next__(self):
        if self.index >= self.max_index:
            raise StopIteration

        item = collection[self.index]
        self.index += 1
        return item
```

We then loop over the collection using:

```python
collection = # user creates collection
iterable = Iterable(collection)
iterator = Iterator(iterable.collection)

# loop over collection
while True:
    try:
        item = iterator.__next__()
        # user adds code here
    except StopIteration:
        break
```

This is an improvement; the loop no longer needs to know details of how to
access the collection or do a range check on the current index.


### Create an iterator using `__iter__()`

While an improvement, the above example still requires that the user knows
what iterator to create, how to create it, and how access the collection inside the
container class. This isn't extensible, so Python requires that we extract the details of
creating the iterator and then expose it with a consistent API: `__iter__()`.
For example:

```python
class Iterable:
    def __init__(self, collection):
        self.collection = collection

    def __iter__(self):
        # Create the correct iterator
        return Iterator(self.collection)
```

which can be used like this:

```python
collection = # user creates collection
iterable = Iterable(collection)

# loop over collection
iterator = iterable.__iter__()
while True:
    try:
        item = iterator.__next__()
        # user adds code here
    except StopIteration:
        break
```

We can now create an iterator for any class that meets Python's iterator protocol.


### Use built-in methods

Python provides built-in functions `iter()` and `next()` that call
`__iter__()` and `__next__()`:

```python
collection = # user creates collection
iterable = Iterable(collection)

# loop over collection
iterator = iter(iterable)
while True:
    try:
        item = next(iterator)
        # user adds code here
    except StopIteration:
        break
```

Both [iter()](https://docs.python.org/3/library/functions.html#iter) and
[next()](https://docs.python.org/3/library/functions.html#next) provide
extra behavior that isn't required for basic iterators so we won't discuss
it here.


### Automatic looping

The above example still nests the user's code in the middle of the loop.
Python provides the `for` statement to remedy this. `for` will handle all
iteration steps automagically, turning this loop:

```python
# loop over collection
iterator = iter(iterable)
while True:
    try:
        item = next(iterator)
        # user adds code here
    except StopIteration:
        break
```
into:

```python
# loop over collection
for item in iterable:
    # user adds code here
```

The `for` statement:
  * creates an iterator using `iter()`
  * calls `next()`
  * stores the `item`
  * checks for the the `StopIteration` exception

Now we can simply write:

```python
collection = # user creates collection
iterable = Iterable(collection)

# loop over collection
for item in iterable:
    # user adds code here
```

Pretty cool!


### Iterators must be iterable

Notice that `for` automatically creates an iterator. What happens if the iterator
already exists and we pass it directly into a `for` loop?

```python
collection = # user creates collection

# create iterator directly
iterator = Iterator(collection)

# loop over collection
for item in iterator:
    # user adds code here
```

It fails:

```
TypeError: 'Iterator' object is not iterable
```

This seems strange; we can't iterate over... an iterator?
This happens because `for` always creates an iterator by calling `iter()`.
To fix this, add a simple `__iter__()` method to our iterator:

```python
class Iterator(self):
    # ...

    def __iter__(self):
        return self
```

The iterator simply returns itself! Now `for` can call `iter()` (which calls
`__iter__()`) and loop properly.


## Example

Here is a simple working example of an iterable and a corresponding iterator:

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

It can be used like this:

```python
# user creates collection
collection = (4, 5, 6)
iterable = Iterable(collection)

# loop over collection
for item in iterable:
    # user adds code here
    print(item)
```

Pretty slick!


## Why not Iterators?

As useful as they are, there are a few downsides to creating iterable classes
using the iterator protocol. You must:

  * create an extra class for the iterator itself
  * explicitly track the iterator's location in the collection across several calls to `__next__()`
  * explicitly check boundary conditions for the collection

To circumvent these issues, Python provides [generators](/generators-in-python/).


## Summary

Python specifies an iterator protocol that allows objects to be passed to `for` loops.
This protocol hides the details of iteration from the caller.

For a class to be iterable, it must:

  * Implement `__iter__()` that returns a valid iterator

A valid iterator must:

  * Implement `__iter__()` that returns itself
  * Implement `__next__()` that
    - returns the next item from the collection
    - raises `StopIteration` when the end of the collecton is reached


## Further Reading

A few useful links in no particular order:

  * Python [tutorial on iterators](https://docs.python.org/3/tutorial/classes.html#iterators)
  * Python docs on the [iterator type](https://docs.python.org/3/library/stdtypes.html#iterator-types)
  * Python [tutorial on the for statement](https://docs.python.org/3/tutorial/controlflow.html#for-statements)
  * Python [reference on the for statement](https://docs.python.org/3/reference/compound_stmts.html#the-for-statement)
  * Iterators in the [Python Practice Book](https://anandology.com/python-practice-book/iterators.html)
