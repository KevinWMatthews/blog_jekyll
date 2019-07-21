---
title: &title "Named Tuples in Python"
permalink: /named-tuples-in-python/
excerpt: "TODO"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - rust
tags:
  - python
  - tuples
---

Named tuples.


## `typing` module

Since Python 3.6.

  * [link](https://stackoverflow.com/questions/2970608/what-are-named-tuples-in-python)
  * [link](https://stackoverflow.com/questions/34269772/type-hints-in-namedtuple/34269877)
  * [link](http://www.attrs.org/en/stable/why.html#namedtuples)
  * [link](https://docs.python.org/3/library/typing.html)

```python
from typing import NamedTuple

class Point(NamedTuple):
    x: int
    y: int = 1

tup = Point(3)
print(tup)
tup = Point(3, 4)
print(tup)
```


Since Python 3.7, but you can install it?

  * [link](https://docs.python.org/3/library/dataclasses.html)

```python
from dataclasses import dataclass

@dataclass
class Point:
    x: int
    y: int = 1

tup = Point(3)
print(tup)
tup = Point(3, 4)
print(tup)
```
