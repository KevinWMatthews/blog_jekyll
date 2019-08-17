---
title: &title "Strings in Python"
permalink: /strings-in-python/
excerpt: "Things to remember"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - python
tags:
  - python
  - map
---


Strings are an immutable sequence [TODO](#).

Concatenate strings using [`string.join()`](#).
Using `join()` requires:

  * a separator in string form (can be an empty string)
  * the strings to concatenate in something iterable

It is used as follows:

```py
separator.join(iterable)
```

For example,
```py
''.join(['one', 'two'])
'|'.join(('one', 'two'))
```
