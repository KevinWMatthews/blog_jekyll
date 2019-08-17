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

Lists *are not* arrays!


## Initializing

Create a list with no elements:

```py
the_list = []
the_list = list()
```

Must add to the list using `append()` or `extend()` - can't refer to a non-existent index.


Create a list with existing elements. These can be modified immediately.

Set all elements of the list to, say, an empty string:

```py
# sequence multiplication
the_list = [''] * list_size
```

```py
# list comprehension
the_list = [for '' in _ range(list_size)]
```

```py
# itertools.repeat()
# # https://docs.python.org/3/library/itertools.html#itertools.repeat
import itertools
the_list = [itertools.repeat('', list_size)]
the_list = list(itertools.repeat('', list_size))
```


## Further Reading

Python docs:

  * [lists](https://docs.python.org/3/tutorial/datastructures.html)
  * [on lists](https://docs.python.org/3/library/stdtypes.html#list)
  * [on sequences](https://docs.python.org/3/library/stdtypes.html#sequence-types-list-tuple-range)
  * [glossary on sequences](https://docs.python.org/3/glossary.html#term-sequence)
  * [ABC for sequences](https://docs.python.org/3/library/collections.abc.html#collections.abc.Sequence)
  * [common sequence operations](https://docs.python.org/3/library/stdtypes.html#typesseq-common)
  * [mutable sequence operations](https://docs.python.org/3/library/stdtypes.html#typesseq-mutable)
  * [list comprehensions](https://docs.python.org/3/tutorial/datastructures.html#list-comprehensions)
