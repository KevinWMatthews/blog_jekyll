---
title: &title "2D Lists in Python"
permalink: /2d-lists-in-python/
excerpt: "Right and wrong ways to create 2d lists"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - python
tags:
  - python
  - lists
  - multidimensional
---

Pitfalls to avoid when creating 2d lists in Python.

For on 1d lists, see [this blog post](/lists-in-python/).


## Source

Find [source code](https://github.com/KevinWMatthews/python-lists-2d) on GitHub.


## Background

A 2d-list in Python can be conceptualized as (row, column) pairs:

```
(0, 0) (0, 1) (0, 2)
(1, 0) (1, 1) (1, 2)
(2, 0) (2, 1) (2, 2)
```

Note that row and column are the **opposite** of traditional x-y coordinate systems!

Rows count along the `-y` axis and are listed first.
Columns count along the `+x` axis and are listed second.
(Alternatively, you can do a coordinate rotation in your head:
`+x` is down, `+y` is right).

Python will represent a 2d-list as a list of lists:

```
[[list], [list], ...]
```

Each list element is itself a list. For example,

```
[   # <-- Outer list
    [00, 01, 02],   # <-- Inner list
    [10, 11, 12],
    [20, 21, 22],
]
```


## Syntax


### `for` Loop with Multiplication

This [Python FAQ](https://docs.python.org/3/faq/programming.html#faq-multidimensional-list)
recommends creating an `M x N` list in two steps:

  * create a list of `M` empty rows
  * fill each row with `N` columns (in a list)

Specifically,

```py
the_list = [None] * nrows
for i in range(nrows):
    the_list[i] = [value] * ncols
```


### Nested List Comprehension

A 2d list can be created with list comprehensions:

```py
[[value for _ in range(ncols)] for _ in range(nrows)]
```

In detail, create a list of columns using:

```py
# List of columns
[value for _ in range(ncols)]
```

We can create rows from these columns using this form:

```py
# List of rows, column unspecified
[column for _ in range(nrows)]
```

Substituting for the column gives the original comprehension.


### List Comprehension with Multiplication

Multiplication can be used for the inner list comprehension (list of columns):

```py
[[value] * ncols for _ in range(nrows)]
```

Do **not** use multiplication for the outer comprehension (list of rows)!
See [Common Mistakes](#common-mistakes) for details.


### Common Mistakes

The following will give unexpected results!

```py
# Do not do this!
[[value] * ncols] * nrows
```

The `*` operator creates a _reference_ to the original object, not a new object.
This means that:

  * The basic type (say, `None`) is referenced multiple times (fine)
  * A *single copy* of the list `[None, None, ...]` is referenced multiple times (bad!)

For example,

```py
[None] * ncols
```

creates a list of references to the `None` type:

```py
[None, None, ...]
```

The problem arises when this is used to populate the rows of a 2d list.
This expression:

```py
[None, None, ...] * nrows
```

creates a list of references to the same list:

```py
[[None, None, ...], [None, None, ...], ...]
```

Changing a single value makes this apparent:

```py
the_list = [[None] * 2] * 3
# [[None, None], [None, None], [None, None]]
the_list[0][0] = 42
# [[42, None], [42, None], [42, None]]
```


## Further Reading

Python docs:

  * Python FAQ [How do I create multidimensional lists?](https://docs.python.org/3/faq/programming.html#faq-multidimensional-list)
  * See Note 2 in [common sequence operations](https://docs.python.org/3/library/stdtypes.html#common-sequence-operations)

Stack Overflow:

  * [nested list comprehension](https://stackoverflow.com/questions/6667201/how-to-define-a-two-dimensional-array-in-python/6667288#6667288)
  * [nested for loops](https://stackoverflow.com/questions/6667201/how-to-define-a-two-dimensional-array-in-python/51217597#51217597)
  * [multiplication and comprehension](https://stackoverflow.com/questions/6667201/how-to-define-a-two-dimensional-array-in-python/31821855#31821855)

Numpy offers an [N-dimensional array](https://numpy.org/devdocs/reference/arrays.ndarray.html).
