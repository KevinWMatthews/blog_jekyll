---
title: &title "Lists in Python"
permalink: /lists-in-python/
excerpt: "List of facts and features about Python's lists"
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


## Initialize

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

## Insert

Python provides the [`insert()`](https://docs.python.org/3/tutorial/datastructures.html#more-on-lists) method for adding a value to a location in the list:

```py
list.insert(i, x)
```

This inserts the value `x` _before_ the index `i`:

```py
the_list = [0, 1, 2]
the_list.insert(1, 42)
# [0, 42, 1, 2]
```

Inserting at index 0 prepends to the list:

```py
the_list = [0, 1, 2]
the_list.insert(0, 42)
# [42, 0, 1, 2]
```

Inserting after the last element appends to the list:

```py
the_list = [0, 1, 2]
the_list.insert(len(the_list), 42)
# [0, 1, 2, 42]

the_list.insert(999, 1000)
# [0, 1, 2, 42, 1000]
```

Inserting to any index of an empty list is safe; it simply creates the first element:

```py
the_list = []
the_list.insert(0, 42)
# [42]

the_list = []
the_list.insert(999, 42)
# [42]
```

## Index

Python provides an [index operator](https://python-reference.readthedocs.io/en/latest/docs/brackets/indexing.html), `[]`.
This maps to a list's [`__getitem__`](https://docs.python.org/3/reference/datamodel.html#object.__getitem__)
or [`__setitem__`](https://docs.python.org/3/reference/datamodel.html#object.__setitem__) methods.
Specifically,

  * `object.__getitem__(self, key)` maps to `self[key]`
  * `object.__setitem__(self, key, value)` maps to `self[key] = value`

Keys may be:

  * integers
  * slices

See "Indexed Assignment", "Indexing", "Slice Assignment", and "Slicing" in Python's [operator module docs](https://docs.python.org/3/library/operator.html#mapping-operators-to-functions).


### With Integer Key

To get and set individual elements of a list, use an integer key.

Get an item in a list using:

```py
the_list = [0, 1, 2]
the_list[1]
# 1
```

Set an item in a list using:

```py
the_list = [0, 1, 2]
the_list[1] = 42
# [0, 42, 2]
```

Both `__getitem__` and `__setitem__` raise an `IndexError` exception if the index is out of range!
This means that `[]` can **not** be used to extend an array with an individual item:

```py
the_list = []
the_list[0] = 42
# IndexError: list assignment index out of range
```


### With Slice Key

To get and set multiple elements in a list, use a [slice](https://docs.python.org/3/glossary.html#term-slice) key.

Get multiple items in a list using:

```py
the_list = [0, 1, 2, 3]
the_list[1:3]
# [1, 2]
```

Note that `[]` returns a value for an integer key,
but for a slice key it returns a list!

Slices do _not_ include the stop element (they are open on the right).
For example, this returns an empty list:

```py
the_list = [0, 1, 2, 3]
the_list[1:1]
# []
```

Set multiple items in a list using:

```py
the_list = [0, 1, 2, 3]
the_list[1:3] = [11, 22]
# [0, 11, 22, 3]
```

An open-ended slice can be used to extend a list:

```py
the_list = [0, 1, 2, 3]
# The key is a slice - note the trailing ':'
the_list[len(the_list):] = [11, 22]
# [0, 1, 2, 3, 11, 22]
```

This is similar to the `extend()` method.

Unlike for an integer key, a slice can be used to extend an empty list:

```py
the_list = []
the_list[0:] = [11, 22]
# [11, 22]
```

Slicing seems to be very sensitive to the index! For example,

```py
# Slice is too small!
the_list = [0, 1, 2, 3]
the_list[1:2] = [11, 22]
# [0, 11, 22, 2, 3]

# Slice is too large!
the_list = [0, 1, 2, 3]
the_list[1:4] = [11, 22]
# [0, 11, 22]
```

I am not yet sure why Python behaves this way.

See also "Slice objects" in Python's [data model](https://docs.python.org/3/reference/datamodel.html).


## Further Reading

Python docs on lists:

  * [Methods on lists](https://docs.python.org/3/tutorial/datastructures.html#more-on-lists)
  * [list type](https://docs.python.org/3/library/stdtypes.html#list)
  * [`list()` builtin function](https://docs.python.org/3/library/functions.html#func-list)
  * [list comprehensions](https://docs.python.org/3/tutorial/datastructures.html#list-comprehensions)

Python docs on sequences:

  * [glossary on sequences](https://docs.python.org/3/glossary.html#term-sequence)
  * [sequences types](https://docs.python.org/3/library/stdtypes.html#sequence-types-list-tuple-range)
  * [`collections.abc.Sequence`](https://docs.python.org/3/library/collections.abc.html#collections.abc.Sequence)
  * [common sequence operations](https://docs.python.org/3/library/stdtypes.html#typesseq-common)
  * [mutable sequence operations](https://docs.python.org/3/library/stdtypes.html#typesseq-mutable)
