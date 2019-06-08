---
title: &title "Iterators in Python"
permalink: /iterators-in-python/
excerpt: "Low-level syntax for putting custom classes in a for loop"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - python
tags:
  - python
  - iterators
---

Iterate over a class using a `for` loop.

## Source

Find [source code]() on GitHub.


## Background

Create classes that can be plugged into a `for` loop.


## Mechanics of Iteration

To introduce how a `for` loop works in Python, let's first naively loop over a
collection and then sequentially introduce Python syntax to make the process
easier and safer.


### Manually loop over collection

Let's say that we have a collection that is stored in a class:

```python
class Iterable:
    def __init__(self):
        self.collection = # user creates collection
```

We would like to loop over this collection and execute some function on each item:

```python
iterable = Iterable()
collection = iterable.collection

# loop over collection
index = 0
max_index = len(collection)

while index < max_index:
    item = collection[item]
    # user adds code here
```

This is effective but error-prone. It requries specific knowledge of both the
class and the collection. We must know where the collection is stored, how to access
individual items, where to start looping, and when to finish looping.
Further, the user must add their code in the middle of a loop - not so clear to read.


### Python iterator type

To isolate the user from these details, we can create a class that does iteration
for us. Python defines a specific protocol; an iterator must:

  * return the next item from the collection using `__next__()`
    - (Python2 requires `next()`)
  * raise `StopIteration` when the end of the collection is reached

A sketch of this looks like:

```python
class Iterator:
    def __init__(self):
        # store collection
        # store current location in collection

    def __next__(self):
        # if reached end of collection, raise StopIteration
        # else return current item and
        # move to next location in collection
```


### Retrieve an item using `__next__()`

Let's convert our example to this new iterator protocol:

```python
class Iterator:
    def __init__(self, collection):
        self.collection = collection
        self.index = 0
        self.max_index = len(collection)

    def __next__(self):
        if index >= max_index:
            raise StopIteration

        item = collection[index]
        self.index += 1
        return item
```

We then loop over the collection using:

```python
collection = # user creates collection
iterator = Iterator(collection)

# loop over collection
while True:
    try:
        item = iterator.__next__()
        # user adds code here
    except StopIteration:
        break
```

This is an improvement; the user no longer needs to know details of how to
access the collection.


### Create an iterator using `__iter__()`

The above example still requires that we know how to create each type of iterator.
What if different iterators require different parameters?
This isn't extensible, so Python requires that we encapsulate this knowledge
in a class and expose it with a consistent API: `__iter__()`. For example:

```python
class Iterable:
    def __init__(self):
        self.collection = # user creates collection

    def __iter__(self):
        # Create the correct iterator
        return Iterator(self.collection)
```

We can then use it like this:

```python
iterable = Iterable()

# loop over collection
iterator = iterable.__iter__()
while True:
    try:
        item = iterator.__next__()
        # user adds code here
    except StopIteration:
        break
```

We can now create an iterator for any class that meets Python's protocol.


### Use built-in methods

Python provides built-in functions `iter()` and `next()` that call
`__iter__()` and `__next__()`:

```python
iterable = Iterable()

# loop over collection
iterator = iter(iterable)
while True:
    try:
        item = next(iterator)
        # user adds code here
    except StopIteration:
        break
```

[iter()](https://docs.python.org/3/library/functions.html#iter) and
[next()](https://docs.python.org/3/library/functions.html#next) provide
extra behavior that isn't required for basic iterators so we won't discuss
it here.


### Automatic looping

The above example still places the user's code in the middle of the loop.
Python provides the `for` statement to fix this. `for` will do
the iteration automagically, turning manual iteration:

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

The `for` loop creates the iterator using `iter()`,
calls `next()`, stores the `item`, and checks for the the `StopIteration`
exception. Now we can simply write:

```python
iterator = Iterable()

# loop over collection
for item in iterable:
    # user adds code here
```

Pretty cool!


### Iterators Must be Iterable

Notice that `for` automatically creates an iterator. What happens if we create
an iterator ourselves (not using out `Iterable` class) and pass it into a `for` loop?

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
AttributeError: 'Iterator' object has no attribute '__iter__'
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


### Summary

Here is the full example:

```python
class Iterable:
    def __init__(self):
        self.collection = # user creates collection

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
iterable = Iterable()

# loop over collection
for item in iterable:
    # user adds code here
```


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

Use it like this:

```python
collection = (4, 5, 6)
iterable = Iterable(collection)

for item in iterable:
    print(item)
```

Pretty slick!


## Why not iterators?

As useful as they are, there are a few downsides to creating iterators directly.
An iterator must:

  * explicitly track its current location in the collection across several calls to `__next__()`
  * checks boundary conditions for the container
  * create an extra class for the iterator itself

To circumvent these issues, read about using [generators](/generators-in-python/).


## Further Reading

A few useful links in no particular order:

  * Python [tutorial on iterators](https://docs.python.org/3/tutorial/classes.html#iterators)
  * Python docs on the [iterator type](https://docs.python.org/3/library/stdtypes.html#iterator-types)
  * Python [tutorial on the for statement](https://docs.python.org/3/tutorial/controlflow.html#for-statements)
  * Python [reference on the for statement](https://docs.python.org/3/reference/compound_stmts.html#the-for-statement)
  * Iterators in the [Python Practice Book](https://anandology.com/python-practice-book/iterators.html)
