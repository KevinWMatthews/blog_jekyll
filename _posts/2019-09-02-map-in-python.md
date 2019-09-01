---
title: &title "The map function in Python"
permalink: /map-function-in-python/
excerpt: "Things to remember"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - python
tags:
  - python
  - map
---

Quick-start on Python's built-in library function [`map()`](https://docs.python.org/3/library/functions.html#map).


## Background

`map()` returns an *iterator* that applies a function to each item in an iterable:

```py
map(function, iterable)
```

The iterator is evaluated lazily - it won't traverse the list until another function requires it.

All sequences in Python are iterable.
Custom types are iterable if they implement the `__iter__()` method.


## Examples

Convert all elements in a list to a string using the builtin `str()`:

```py
numbers = [1, 2, 3]
iterator = map(str, numbers)
strings = list(iterator)
```

Double all elements in a list using a custom function:

```py
numbers = [1, 2, 3]

def double_it(value):
    return value * 2

iterator = map(double_it, numbers)
doubled = list(iterator)
```


## Further Reading

  * [Python docs](https://docs.python.org/3/library/functions.html#map)
  * [pythontips](http://book.pythontips.com/en/latest/map_filter.html)
