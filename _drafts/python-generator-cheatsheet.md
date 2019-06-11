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

Generators can be used to make a class iterable - an instance can be passed directly
into a `for` loop:

```python
class Iterable:
    # ...

for item in Iterable():
    # ...
```

`__iter__()` will return a generator object that is only evaluated when necessary.

Similarly, generators can be used to make a function iterable:
```python
def function():
    # ...

for item in function():
    # ...
```

## Syntax

To make a class iterable, create an `__iter__()` method and use the `yield`
keyword to "return" a value:

```python
class Iterable:
    def __iter__(self):
        for item in collection:
            yield item
```

To make a function iterable, simply `yield` instead of returning:

```python
def function(collection):
    for item in collection:
        yield item
```


## Examples

Iterable class:

```python
class Iterable:
    def __init__(self, collection):
        self.collection = collection

    def __iter__(self):
        for item in self.collection:
            yield item


collection = [7, 8, 9]
iterable = Iterable(collection)

for item in collection:
    print(item)
```

Iterable function:

```python
def iterate_over(collection):
    for item in collection:
        yield item

collection = [7, 8, 9]
for item in iterate_over(collection):
    print(item)
```

An iterable function can be standalone or a method of a class.

These are trivial examples; in this case one could iterate directly on the
collection with the same effect. In a real-world scenario, the generator
function would do extra processing that provides some added value.


## Further Reading

Links to Python documentation in no particular order.

  * Python3 tutorial: [generators](https://docs.python.org/3/tutorial/classes.html#generators)
  * Python3 reference: [generators](https://docs.python.org/3/glossary.html#term-generator)
  * Python3 reference: [yield statement](https://docs.python.org/3/reference/simple_stmts.html#the-yield-statement)
  * Python3 reference: [yield expressions](https://docs.python.org/3/reference/expressions.html#yield-expressions)
  * Python3 reference: [methods on generator iterators](https://docs.python.org/3/reference/expressions.html#generator-iterator-methods)
  * Python3 how-to: [generators](https://docs.python.org/3/howto/functional.html#generators)
