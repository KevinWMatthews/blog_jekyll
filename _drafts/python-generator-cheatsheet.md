---
title: &title "Generator Cheat Sheet"
permalink: /python-generator-cheat-sheet/
excerpt: "Quickstart for Python generators"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - python
tags:
  - python
  - generators
---

Example of Python generator syntax. For details, see the
[generators](/generators-in-python/) post.

## Source

Find [source code]()
and [documentation]() on GitHub.


## Quasi-code

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
    index = 0
    max_index = len(self.collection)
    while index < max_index:
      yield self.collection[index]
      index += 1

collection = [9, 8, 7]
iterable = Iterable(collection)
for item in collection:
  print(item)
```

Iterable function:

```python
def iterate_over(collection):
  for item in collection:
    yield item

collection = [9, 8, 7]
for item in iterate_over(collection):
  print(item)
```

These are trivial examples; in this case one could iterate directly on the
collection with the same effect. In a real-world scenario, the generator
function would do extra processing.
