---
title: &title "Strings in Python"
permalink: /strings-in-python/
excerpt: "Reference on the ins and outs of Python strings"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - python
tags:
  - python
  - strings
---

Notes on strings in Python.


## Background

Strings are an [immutable sequence type](https://docs.python.org/3.7/library/stdtypes.html#textseq).

Strings can *not* be modified using [operations for mutable sequence types](https://docs.python.org/3.7/library/stdtypes.html#mutable-sequence-types) such as `[]`, `insert()`, or `append()`.
Any operation that appears to change a string actually creates a new copy of the string.


## Concatenation

Strings can be concatenated using sequence operator `+`, but this is ineficcient
(see [Joel Spolksy's article](https://www.joelonsoftware.com/2001/12/11/back-to-basics/) and the [Wiki on Schlemiel the Painter](https://en.wikipedia.org/wiki/Joel_Spolsky#Schlemiel_the_Painter's_algorithm)).
Instead, concatenate strings using [`string.join()`](https://docs.python.org/3.7/library/stdtypes.html#str.join).

Using `join()` requires:

  * a separator in string form (can be an empty string)
  * the strings to concatenate in something iterable

It is used as follows:

```py
separator.join(iterable)
```

For example,
```py
>>> ''.join(['one', 'two'])
onetwo

>>> '|'.join(('one', 'two'))
one|two
```


## Useful Methods

See [all string methods](https://docs.python.org/3.7/library/stdtypes.html#string-methods)

  * [`join()`](https://docs.python.org/3.7/library/stdtypes.html#str.join)
  * [`partition()`](https://docs.python.org/3.7/library/stdtypes.html#str.partition)
  * [`split()`](https://docs.python.org/3.7/library/stdtypes.html#str.split)
  * [`splitlines()`](https://docs.python.org/3.7/library/stdtypes.html#str.splitlines)


## Further Reading

Python docs:

  * [str as text sequence type](https://docs.python.org/3.7/library/stdtypes.html#textseq)
  * [string methods](https://docs.python.org/3.7/library/stdtypes.html#string-methods)
  * [common sequence operations](https://docs.python.org/3.7/library/stdtypes.html#typesseq-common)
  * [common string operations](https://docs.python.org/3.7/library/string.html)
