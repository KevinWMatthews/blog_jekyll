---
title: &title "Reduce in Python"
permalink: /reduce-in-python/
excerpt: "Introduction to the reduce() function in Python"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - python
tags:
  - python
  - reduce
---

Introduction to `functools.reduce()` in Python 3.
Operate on a sequence of data and produce a single result.


## Source

See [this gist](https://gist.github.com/KevinWMatthews/b41fc15da2cccdd9c16f8da09b58ac8d).


## Background

This is a quick example; see the above gist.


## Examples

Sum the items in a list:

```py
import functools
input = (2, 1, 3)
add_to_total = lambda total, value: total + value
total = functools.reduce(add_to_total, input)
```

Of course, one should typically use Python's built-in function [`sum`](https://docs.python.org/3/library/functions.html#sum).

Find the minimum in a list:

```py
import functools
input = (2, 1, 3)
smaller_of_two = lambda min, value: min if min < value else value
minimum = functools.reduce(smaller_of_two, input)
```

Of course, one should typically use Python's built-in function [`min`](https://docs.python.org/3/library/functions.html#min).

Find the maximum in a list:

```py
import functools
input = (2, 1, 3)
larger_of_two = lambda max, value: max if max > value else value
maximum = functools.reduce(larger_of_two, input)
```

Of course, one should typically use Python's built-in function [`max`](https://docs.python.org/3/library/functions.html#max).


## Further Reading

  * Python 3 [standard library docs](https://docs.python.org/3/library/functools.html#functools.reduce)
  * [Python Tips book](http://book.pythontips.com/en/latest/map_filter.html#reduce)
  * [Stack Overflow post](https://stackoverflow.com/questions/13638898/how-to-use-filter-map-and-reduce-in-python-3/13638960#13638960)
