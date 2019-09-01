---
title: &title "Lists in Python"
permalink: /lists-in-python/
excerpt: "Things to remember"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - python
tags:
  - python
  - lists
---

A cheat-sheet on Python lists.

## Source

Find [source code](https://github.com/KevinWMatthews/python-lists) on GitHub.


## Background

[Lists](https://docs.python.org/3/tutorial/datastructures.html#more-on-lists) are one of Python's most common [sequence types](https://docs.python.org/3/library/stdtypes.html#sequence-types-list-tuple-range).

Lists are optimized for:

  * access by index
  * iteration
  * append to end
  * pop/remove from end

that is, as an array or a stack (last-in, first-out).

A list can be used as a queue (first-in, first-out),
but operations on the front of the list are expensive.
Use a [deque](https://docs.python.org/3/library/collections.html#collections.deque) instead.

While lists roughly correspond to a C-style arrays,
Python has a separate [array](https://docs.python.org/3/library/array.html) type that is streamlined for numeric values.


## Initializing

### Empty

To create a list with no elements, use square brackets or the [list builtin](https://docs.python.org/3/library/functions.html#func-list):

```py
the_list = []
the_list = list()
```

At this point the list has no elements; indexing into the list is an error.
The list must be extended using `insert()`, `append()` or `extend()`.
See Python's docs on [data structures](https://docs.python.org/3/tutorial/datastructures.html).


### With Elements

A list can be initialized with elements:

```py
# syntactic sugar
the_list = [1, 2, 3]

# list(iterable)
the_list = list([1, 2, 3])
```


### With Multiplication

Like all sequences, lists support [multiplication](https://docs.python.org/3/library/stdtypes.html#typesseq-common):

```py
# sequence multiplication
the_list = [''] * list_size
```

The list elements are **not** new copies of the object;
they are references to *the same object*.
This has implications for [creating 2d lists](/2d-lists-in-python/).


### With List Comprehensions

Lists can also be created using [list comprehensions](https://docs.python.org/3/tutorial/datastructures.html#list-comprehensions):

```py
# list comprehension
the_list = ['' for _ in range(list_size)]
```


### With `itertools`

The above methods can be combined with other library functions such as
[`itertools.repeat()`](https://docs.python.org/3/library/itertools.html#itertools.repeat):

```py
import itertools
the_list = list(itertools.repeat('', list_size))
```


## Further Reading

Python docs:

  * [Data Structures: list](https://docs.python.org/3/tutorial/datastructures.html#more-on-lists)
  * [stdtypes: list](https://docs.python.org/3/library/stdtypes.html#list)
  * [`list()` builtin function](https://docs.python.org/3/library/functions.html#func-list)
  * [sequences types](https://docs.python.org/3/library/stdtypes.html#sequence-types-list-tuple-range)
  * [glossary on sequences](https://docs.python.org/3/glossary.html#term-sequence)
  * [`collections.abc.Sequence`](https://docs.python.org/3/library/collections.abc.html#collections.abc.Sequence)
  * [common sequence operations](https://docs.python.org/3/library/stdtypes.html#typesseq-common)
  * [mutable sequence operations](https://docs.python.org/3/library/stdtypes.html#typesseq-mutable)
  * [list comprehensions](https://docs.python.org/3/tutorial/datastructures.html#list-comprehensions)
