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
---

If you're already comfortable with generators, look at the
[generator cheat sheet]().

TODO generator vs generator function
Reread [this](https://anandology.com/python-practice-book/iterators.html)
Resources?

## Source

Find [source code]()
and [documentation]() on GitHub.


## Background

Generators are syntactic sugar around [iterators](/iterators-in-python/):

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

  def __next__(self):
    if self.index >= self.max_index:
      raise StopIteration

    item = self.collection[self.index]
    self.index += 1
    return item
```

The iterator is responsible for maintaining internal state - where it was in
the collection when `__next__` was last called.

Iterators use `__next__` (by calling the built-in `next()`) to:

  * returns a value from the collection
  * raise `StopIteration` when the end of the collection is reached

Python has in a language feature to help us do this automagically: `yield`.
(`yield` creates a generator?).

Here is some pseudo-ish code:

```python
class Iterable:
  def __iter__(self):
    while item_left_in_collection:
      yield item_in_collection
      move to next item
```

In detail, it could look like this:
```python
class Iterable:
  def __init__(self, collection):
    self.collection = collection

  def __iter__(self):
    index = 0
    max_index = len(collection)
    while index < max_index:
      yield collection[index]
      index += 1
```

The magic stems from the keyword `yield`. This tells Python to create a to
create [generator function](https://docs.python.org/3/glossary.html#term-generator)
instead of a function object. Python knows that this will return a series of values
(using `next()`) instead of a single return value.

Due to the `yield` keyword, the generator function will return a
[generator iterator](https://docs.python.org/3/glossary.html#term-generator-iterator)
instead of a standard iterator.

 Generator iterators do a lot of magic behind the scenes:
  * create `__iter__()` and `__next__()` automatically.
  * track local variables between calls
  * raise `StopIteration` automatically

When `next()` is called, the generator iterator will execute the code it contains
until `yield` is reached. At this point, it suspends execution, gives control
to the caller, and provides its argument (hopefully an item in the collection)
to the caller.

Notice that is is easier for a generator to track the state in the collection -
a generator can use local variables since these are automagically stored between calls.

This is best thought of at the high level:
for each item in the collection, `__next__` must yield flow control and provide
an item.

Another way to think of this is to look at a `for` loop:

```python
for item in iterable:
  # body of foor loop - user code here
```
`yield` fills in the item and lets the body of the `for` loop run once, then
the `for` loop calls the generator iterator again.

In detail, `for` creates an iterator using `iter()`.
It calls `next()` on this iterator, which provides a single item from the
collection. The body of the for loop runs once. Once it is finished,
`for` calls `next()` again. The process repeats until the iterator raises
`StopIteration`.


### Under the Hood

Just barely.

One can still call the `__next__` method manually - generators seem to provide this.
```python
iterator = iterable.__iter__()
while True:
  try:
    item = iterator.__next__()
    # user code here
  except StopIteration:
    break
```
