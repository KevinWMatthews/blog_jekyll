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

Find [source code](https://github.com/KevinWMatthews/python-generator_cheatsheet)
on GitHub.


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
function would do extra processing.


## Further Reading

Links to Python documentation in no particular order.

  * Python3 tutorial: [generators](https://docs.python.org/3/tutorial/classes.html#generators)
  * Python3 reference: [generators](https://docs.python.org/3/glossary.html#term-generator)
  * Python3 reference: [yield statement](https://docs.python.org/3/reference/simple_stmts.html#the-yield-statement)
  * Python3 reference: [yield expressions](https://docs.python.org/3/reference/expressions.html#yield-expressions)
  * Python3 reference: [methods on generator iterators](https://docs.python.org/3/reference/expressions.html#generator-iterator-methods)
  * Python3 how-to: [generators](https://docs.python.org/3/howto/functional.html#generators)
