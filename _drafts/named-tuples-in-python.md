---
title: &title "Named Tuples in Python"
permalink: /named-tuples-in-python/
excerpt: "Introduction to named tuples with syntax and alternatives"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - python
tags:
  - python
  - tuples
---

Short exploration of named tuples in Python.


## Source

Find [source code](https://github.com/KevinWMatthews/python-named_tuples) on GitHub.


## Background

Named tuples can be used to create custom tuple data type that allows access by field name, much like a dictionary:

```py
import collections

# Create tuple type
typename = 'Point'
field_names = ('x', 'y')
Point = collections.namedtuple(typename, field_names)

# Instantiate tuple
point = Point(x=0, y=1)

# Access
point.x
point.y

point[0]
point[1]
```

As with all Python tuples, assignment is not allowed.



## `collections` module

Since Python 3.

The `collections` module offers the function [`namedtuple`](https://docs.python.org/3/library/collections.html#collections.namedtuple).
Use it to create a custom tuple type:

```py
typename = 'Point'
field_names = ('x', 'y')
Point = collections.namedtuple(typename, field_names)
```

`namedtuple` requires two arguments: `typename` and `field_names`.
By convention, the new tuple object is stored in a variable with the same name as the typename.

It is possible to set default arguments for a `namedtuple`.
See the [`namedtuple` docs](https://docs.python.org/3/library/collections.html#collections.namedtuple).

This custom tuple type object can be used to instantiate individual tuples:

```py
point = Point(x=0, y=1)
```

A `namedtuple` offers flexibility when initializing:

```py
# No keywords
Point(0, 1)
# With keywords
Point(x=0, y=1)
# Keywords in any order
Point(y=1, x=0)
```

However, values for all field names must be provided.

Accessing values is similarly flexible:

```py
point[0]
point.x
point[1]
point.y
```

Tuples are *not* a dictionary, so access by key is not allowed:

```py
# Error
point['x']
```
```
TypeError: tuple indices must be integers or slices, not str
```

As with all tuples, assignment after initialization is not allowed:

```py
# Error
point.x = 42
```

```
TypeError: 'Point' object does not support item assignment
```



### Inspection

Add `verbose=True` to inspect the class that Python creates automatically:

```py
Point(typename, field_names, verbose=True)
```

You will see the output:

```py
class Point(tuple):
    'Point(x, y)'

    __slots__ = ()

    _fields = ('x', 'y')

    def __new__(_cls, x, y):
        'Create new instance of Point(x, y)'
        return _tuple.__new__(_cls, (x, y))

    @classmethod
    def _make(cls, iterable, new=tuple.__new__, len=len):
        'Make a new Point object from a sequence or iterable'
        result = new(cls, iterable)
        if len(result) != 2:
            raise TypeError('Expected 2 arguments, got %d' % len(result))
        return result

    def _replace(_self, **kwds):
        'Return a new Point object replacing specified fields with new values'
        result = _self._make(map(kwds.pop, ('x', 'y'), _self))
        if kwds:
            raise ValueError('Got unexpected field names: %r' % list(kwds))
        return result

    def __repr__(self):
        'Return a nicely formatted representation string'
        return self.__class__.__name__ + '(x=%r, y=%r)' % self

    def _asdict(self):
        'Return a new OrderedDict which maps field names to their values.'
        return OrderedDict(zip(self._fields, self))

    def __getnewargs__(self):
        'Return self as a plain tuple.  Used by copy and pickle.'
        return tuple(self)

    x = _property(_itemgetter(0), doc='Alias for field number 0')

    y = _property(_itemgetter(1), doc='Alias for field number 1')
```

Of primary interest is the `__new__` method;
this shows the arguments that are required to initialize the object.


## `typing` module

Since Python 3.6, `namedtuples` with strict typing can be created using the [`typing` module](https://docs.python.org/3/library/typing.html#typing.NamedTuple):

```python
from typing import NamedTuple

class Point(NamedTuple):
    x: int
    y: int = 1
```

Note that individual fields are typed!
A default value is optional.

Instantiate as any other class:

```py
point = Point(3, 4)
point = Point(3)        # uses default value
```

Access using field names:

```py
point.x
point.y
```



## `dataclass`

Since Python 3.7, a similar effect can be achieved using the [`dataclass` module](https://docs.python.org/3/library/dataclasses.html#module-dataclasses).
`dataclass`es add special access methods for fields.

Create a custom `dataclass` similar to a typed `NamedTuple` but with the `@dataclass` decorator:

```python
from dataclasses import dataclass

@dataclass
class Point:
    x: int
    y: int = 1
```

As with the `typing` module, fields must be typed and a default value is optional.

Instantiate normally:

```py
point = Point(3, 4)
point = Point(3)        # uses default value
```

And access similarly:

```py
point.x
point.y
```


## Further Reading

Python3 docs for:

  * [`collections.namedtuple`](https://docs.python.org/3/library/collections.html#collections.namedtuple)
  * [`typing.NamedTuple`](https://docs.python.org/3/library/typing.html#typing.NamedTuple)
  * [`dataclasses.dataclass`](https://docs.python.org/3/library/dataclasses.html#dataclasses.dataclass)

See also:

  * [Named tuples on Stack Overflow](https://stackoverflow.com/questions/2970608/what-are-named-tuples-in-python)
  * [Typed named tuples on Stack Overflow](https://stackoverflow.com/questions/34269772/type-hints-in-namedtuple/34269877)
  * [Gits on Named Tuples](https://gist.github.com/andilabs/15002176b2bda786b9037077fa06cc71)
  * [Docs from the `attrs` package](http://www.attrs.org/en/stable/why.html#namedtuples)
