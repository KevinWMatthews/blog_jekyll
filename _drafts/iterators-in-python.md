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

Find [source code]()
and [documentation]() on GitHub.


## Background

Create classes that can be plugged into a `for..in` loop.

Let's create a naive narrative of how a `for` loop works in Python and then
show how Python syntax makes the process easier.

`for` is a language feature. The core behavior is that `for _ in object`
calls `__next__` (or `next` in Python2) until it catches the `StopIteration` exception.

Something like this:

```python
class Iterator:
    def __init__(self):
        pass

    def __next__(self):
        #TODO

# for..in does this:
iterator = Iterator()
while True:
  try:
    iterator.__next__()
  except StopIteration:
    break
```

To be useful, `__next__` should return an item from the collection.
The caller can use this item as they please:
```python
class Iterator:
  def __init__(self, collection):
    self.collection = collection

  def __next__(self):
    # return an item from the collection
    # or raise StopIteration

iterator = Iterator(some_collection)
while True:
  try:
    item = iterator.__next__()
    # user adds code here
  except StopIteration:
    break
```

The collection that we are iterating over is typically stored in a class. Python
requires that this class knows how to create its own iterator (what else would?)
and also requires that the API for this is consistent: `__iter__`.

```python
class Iterable:
  def __init__(self):
    self.collection = # Create your collection

  def __iter__(self):
    return Iterator(self.collection)
```

We can then use it like this:
```python
iterable = Iterable(params)

iterator = iterable.__iter__()
while True:
  try:
    item = iterator.__next__()
    # user adds code here
  except StopIteration:
    break
```

Our looping construct can now consistently create an iterator for any class.

The manual looping process is verbose and error prone, and hides the user's
code in the middle of the loop. `for..in` cleans up the syntax by doing the
iterationautomagically, turning manual iteration:
```python
iterator = iterable.__iter__()
while True:
  try:
    item = iterator.__next__()
    # user adds code here
  except StopIteration:
    break
```
into:
```python
for item in iterable:
  # user adds code here
```

The `for` loop automatically creates the iterator using `__iter__`,
calls `__next__`, stores the `item`, and checks for the the `StopIteration`
exception. Pretty cool!

Here is a working Iterable and a corresponding Iterator:
```python
class Iterable:
  """Iterable class

  Must be able to retrieve items from the collection using [] and an index.
  """

  def __init__(self, collection):
    self.collection = collection

  def __iter__(self):
    return Iterator(collection)

class Iterator:
  """Iterator for an Iterable class.

  Must be able to retrieve items from the collection using [] and an index.
  """

  def __init__(self, collection):
    self.collection = collection
    # Must track the curerent index while iterating
    self.index = 0
    self.max_index = len(collection)

  def __next__(self):
    if self.index >= self.max_index:
      raise StopIteration

    item = self.collection[self.index]
    self.index += 1
    return item
```

We can use it like this:
```python
collection = (4, 5, 6)
iterable = Iterable(collection)

for item in iterable:
  print(item)
```

The use case is nice, but the setup is a bit intense.
To see how to reduce this, look at [generators](/generators-in-python/).
