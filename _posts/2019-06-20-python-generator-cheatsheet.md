---
title: &title "Python Generator Cheat Sheet"
permalink: /python-generator-cheatsheet/
excerpt: "Quickstart for Python generators"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - python
tags:
  - python
  - generators
  - iteration
  - cheatsheet
---

Reference for Python generator syntax. For a detailed introduction to generators,
see blog posts on [iterators](/iterators-in-python/) and [generators](/generators-in-python/).


## Source

Find [source code](https://github.com/KevinWMatthews/python-generator_cheatsheet)
on GitHub.


## Background

Generators can be used to make a class or a function iterable.
Python will create a generator when it encounters the `yield` keyword in a function.

To make a class iterable, implement an `__iter__()` method with `yield`.
An instance of the class can then be passed directly into a `for` loop.

```python
class Iterable:
    def __iter__(self):
        # loop over collection
        yield   # each item in collection

for item in Iterable():
    # use item
```

`__iter__()` will return a generator object that is only evaluated when necessary.

To make a function iterable, use `yield`:

```python
def function():
    # loop over collection
    yield   # each item in collection

for item in function():
    # use item
```


## Examples


### Iterable class

Implement `__iter__()` with `yield`:

```python
class Iterable:
    def __init__(self, collection):
        self.collection = collection

    def __iter__(self):
        for item in self.collection:
            yield item
```

Then pass an instance of the class to `for:`

```python
>>> collection = [7, 8, 9]
>>> iterable = Iterable(collection)
>>> for item in iterable:
...     print(item)
...
7
8
9
```


### Iterable function

Implement a function with `yield`:

```python
def iterate_over(collection):
    for item in collection:
        yield item
```

Then call the function in `for`:
```python
>>> collection = [7, 8, 9]
>>> for item in iterate_over(collection):
...     print(item)
...
7
8
9
```


### Return

A generator iterator raises the `StopIteration` exception when it returns,
either at the end of a function or from the `return` keyword.

```python
def iterable_function():
    for i in range(1, 10):
        if i > 3:
            return
        yield i
```

```python
>>> for item in iterable_function():
...     print(item)
...
1
2
3
```


## Further Reading

Links to Python documentation in no particular order.

  * Python3 tutorial: [generators](https://docs.python.org/3/tutorial/classes.html#generators)
  * Python3 reference: [generators](https://docs.python.org/3/glossary.html#term-generator)
  * Python3 reference: [yield statement](https://docs.python.org/3/reference/simple_stmts.html#the-yield-statement)
  * Python3 reference: [yield expressions](https://docs.python.org/3/reference/expressions.html#yield-expressions)
  * Python3 reference: [methods on generator iterators](https://docs.python.org/3/reference/expressions.html#generator-iterator-methods)
  * Python3 how-to: [generators](https://docs.python.org/3/howto/functional.html#generators)
