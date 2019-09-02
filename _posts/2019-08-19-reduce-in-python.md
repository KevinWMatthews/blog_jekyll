---
title: &title "The reduce() function in Python"
permalink: /reduce-function-in-python/
excerpt: "Cheatsheet for Python's reduce function"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - python
tags:
  - python
  - reduce
---

Cheatsheet for [`functools.reduce()`](https://docs.python.org/3/library/functools.html#functools.reduce) in Python 3.

`for` loops seem to be more prevalent in Python.


## Source

See [this gist](https://gist.github.com/KevinWMatthews/b41fc15da2cccdd9c16f8da09b58ac8d).


## Background

`reduce()` will:

  * operate on a sequence of data
  * produce a single result

The signature of `reduce()` is:

```py
reduce(function, iterable[, initializer])
```

where:

  * `function` performs the operation
  * `iterable` is the sequence of data
  * `initializer` is an optional first value for the accumulator

The signature of the `function` should be similar to:

```py
def function(accumulator, value):
```

where `accumulator` is a running total and `value` is the current value in the collection.


## Examples


### Sum

Sum the items in a list:

```py
import functools
input = (2, 1, 3)
add_to_total = lambda total, value: total + value
total = functools.reduce(add_to_total, input)
```

Of course, one should typically use Python's built-in function [`sum`](https://docs.python.org/3/library/functions.html#sum).


### Minimum

Find the minimum in a list:

```py
import functools
input = (2, 1, 3)
smaller_of_two = lambda min, value: min if min < value else value
minimum = functools.reduce(smaller_of_two, input)
```

Of course, one should typically use Python's built-in function [`min`](https://docs.python.org/3/library/functions.html#min).


### Maximum

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
