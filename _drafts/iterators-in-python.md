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

We would like to execute some user behavior for each item in a user-defined
collection:

```python
collection = # user creates collection
index = 0
max_index = len(collection)

while index < max_index:
    item = collection[item]
    # user adds code here
```

This is effective but error-prone. We could accidentaly start at the wrong index
or loop off the end of the collection. Further, the user must add their
code in the middle of a loop - not so clear to read.


### Python iterator type

To prevent the user from having to track indices, we can create a class that does
this for us. Python defines a specific API. An iterator must:

  * return the next item from the collection using `__next__()` (Python2 requires `next()`)
  * raise `StopIteration` when the end of the collection is reached

A sketch of this looks like:

```python
class Iterator:
    def __init__(self):
        # store collection
        # store current location in collection

    def __next__(self):
        # if end of collection, raise StopIteration
        # else return current item and move to next location in collection
```

We then loop over the collection using:

```python
collection = # user creates collection
iterator = Iterator(collection)
while True:
    try:
        item = iterator.__next__()
        # user adds code here
    except StopIteration:
        break
```


### Retrieve an item using `__next__()`

Let's convert our example to this new API:

```python
class Iterator:
    def __init__(self, collection):
        self.collection = collection
        self.index = 0
        self.max_index = len(collection)

    def __next__(self):
        if index >= max_index:
            raise StopIteration

        item = collection[item]
        self.index += 1
        return item
```

We use it like this:

```python
collection = # user creates collection
iterator = Iterator(collection)
while True:
    try:
        iterator.__next__()
    except StopIteration:
        break
```


### Retrieve an item using

The `for` statement is a Python language feature. The core behavior is that
`for _ in object` creates an iterator and calls its `__next__()` method
(or `next()` in Python2) until the iterator raises the `StopIteration` exception.

Something like this:

```python
class Iterator:
    def __init__(self):
        pass

    def __next__(self):
        # return an item from the collection
        # or raise StopIteration

# for does this:
iterator = Iterator()
while True:
    try:
        iterator.__next__()
    except StopIteration:
        break
```

To be useful, `__next__()` should return an item from the collection:

```python
class Iterator:
    def __init__(self, collection):
        self.collection = collection

    def __next__(self):
        # return an item from the collection
        # or raise StopIteration

# for does this
iterator = Iterator(some_collection)
while True:
    try:
        item = iterator.__next__()
        # user adds code here
    except StopIteration:
        break
```


### Create an iterator using `__iter__()`

The above example requires that `for` know how to create an iterator.
This isn't extensible, so Python requires that this class knows how to create
its own iterator (what else would?) and that it expose this with a consistent API:
`__iter__()`. For example:

```python
class Iterable:
    def __init__(self):
        self.collection = # Create collection

    def __iter__(self):
        return Iterator(self.collection)

class Iterator:
    def __init__(self, collection):
        self.collection = collection

    def __next__(self):
        # return an item from the collection
        # or raise StopIteration
```

We can then use it like this:

```python
iterable = Iterable()

# for does this
iterator = iterable.__iter__()
while True:
    try:
        item = iterator.__next__()
        # user adds code here
    except StopIteration:
        break
```

The for loop can now create an iterator for any class.


### Use built-in methods

Python provides built-in functions `iter()` and `next()` that call
`__iter__()` and `__next__()`:

```python
iterable = Iterable()

# for does this
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

The manual looping process is verbose and error prone, and hides the user's
code in the middle of the loop. The `for` statement cleans up the syntax by doing
the iteration automagically, turning manual iteration:

```python
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
for item in iterable:
    # user adds code here
```

The `for` loop creates the iterator using `iter()`,
calls `next()`, stores the `item`, and checks for the the `StopIteration`
exception. Now we can simply write:

```python
iterator = Iterable()
for item in iterable:
    # user adds code here
```

Pretty cool!


### Iterators Must be Iterable

Notice that `for` automatically creates an iterator. What happens if we create
an iterator ourselves (not using the `Iterable` class) and pass it into a `for` loop?

```python
class Iterator:
    def __init__(self):
        # Store collection

    def __next__(self):
        # return an item from the collection
        # or raise StopIteration

collection = # user creates collection
iterator = Iterator(collection)   # create iterator directly
for item in iterator:
    # user adds code here
```

It fails:
```
AttributeError: 'Iterator' object has no attribute '__iter__'
```

This seems strange... we can't iterate over an iterator?
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


### Recap

Here is the full example:

```python
class Iterable:
    def __init__(self):
        self.collection = # Create your collection

    def __iter__(self):
        return Iterator(self.collection)

class Iterator:
    def __init__(self, collection):
        self.collection = collection

    def __iter__(self):
      return self

    def __next__(self):
        # return an item from the collection
        # or raise StopIteration
```

It can be used like this:

```python
iterable = Iterable()
for item in iterable:
    # user adds code here
```


## Tracking internal state

Thus far we've glossed over how the iterator actually extracts an item from
the collection. To do this, the iterator must know where it is in the collection
across several calls to `__next__()`.

```python
class Iterator:
    def __init__(self, collection):
        self.collection = collection
        # store current location in collection

    def __next__(self):
        # if item in collection, return item and move to next location
        # else raise StopIteration
```

The iterator must explictly track its current location in the collection.

This may be more clear with an example.


### Example

Here is an example of a functioning iterable and a corresponding iterator:

```python
class Iterable:
    def __init__(self, collection):
        self.collection = collection

    def __iter__(self):
        return Iterator(collection)

class Iterator:
    def __init__(self, collection):
        self.collection = collection
        # Must track the curerent index while iterating
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

The iterator explicitly tracks its current location in the collection and also
checks boundary conditions for the container.

While it is useful, these explicit checks are error-prone.
To circumvent these problems, Python provides [generators](/generators-in-python/).
In the meantime, we can use this iterator as follows:

```python
collection = (4, 5, 6)
iterable = Iterable(collection)

for item in iterable:
    print(item)
```

Pretty slick!


## Further Reading

  * Iterators in the [Python Practice Book](https://anandology.com/python-practice-book/iterators.html)
  * Python docs on the [iterator type](https://docs.python.org/3/library/stdtypes.html#iterator-types)
  * Python [tutorial on the for statement](https://docs.python.org/3/tutorial/controlflow.html#for-statements)
  * Python [reference on the for statement](https://docs.python.org/3/reference/compound_stmts.html#the-for-statement)
