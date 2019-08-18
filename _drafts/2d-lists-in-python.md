---
title: &title "2D Lists in Python"
permalink: /2d-lists-in-python/
excerpt: "Things to remember"
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

Syntax gotchas:

```py
[[value] * cols] * rows
```

doesn't work!
The `*` operator creates a reference to the original object, not a new object.
This means that:

  * The basic type (say, `None`) is referenced multiple times (fine)
  * A *single copy* of the array `[None, None, ...]` is referenced multiple times (bad!)


The Python docs recommend creating a list of empty rows,
then filling each row with a distinct column object:

```py
the_list = [value] * nrows
for row in the_list:
    row = [value] * ncols
```

This can also be done with list comprehensions:

```py
# Single row - has n columns
[value for _ in ncols]

# Set of rows, column unspecified
[column for _ in nrows]

# Properly specify columns
[[value for _ in ncols] for _ in nrows]
```
