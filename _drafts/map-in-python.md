---
title: &title "The map function in Python"
permalink: /map-function-in-python/
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

Returns an *iterator* that applies a function to each item in an iterable:

```py
map(function, iterable)
```

For example, convert all elements in a list to a string:

```py
numbers = [1, 2, 3]
iterator = map(str, numbers)
strings = list(iterator)
```


## Further Reading

  * [Python docs](https://docs.python.org/3/library/functions.html#map)
  * [pythontips](http://book.pythontips.com/en/latest/map_filter.html)
