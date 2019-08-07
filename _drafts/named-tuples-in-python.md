---
title: &title "Named Tuples in Python"
permalink: /named-tuples-in-python/
excerpt: "Create custom tuple types with member access by field name"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - python
tags:
  - python
  - tuples
---

Create custom tuples with named members.
These allow member access by field name as well as by index.


## Source

Find [source code](https://github.com/KevinWMatthews/python-named_tuples) on GitHub.


## `collections` module

The `collections` module offers the function [`namedtuple`](https://docs.python.org/3/library/collections.html#collections.namedtuple).
Use it to create a custom tuple type:

```py
typename = 'Point'
field_names = ('x', 'y')
Point = collections.namedtuple(typename, field_names)
```

`namedtuple` requires two arguments: `typename` and `field_names`.
`typename` is a string, `field_names` is an iterable.
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

Available since Python 3.


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

The `__new__` method is of interest;
this shows the arguments that are required to create a named tuple.


## `typing` module

Since Python 3.6, `namedtuples` with strict typing can be created using the [`typing` module](https://docs.python.org/3/library/typing.html#typing.NamedTuple):

```python
import typing

class Point(typing.NamedTuple):
    x: int
    y: int = 0
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

Since Python 3.7, a similar effect can be achieved using the [`dataclasses` module](https://docs.python.org/3/library/dataclasses.html#module-dataclasses).
The `dataclass` decorator adds special methods to a class, allowing easy access to fields by name.

The result is similar to but distinct from a named tuple:

```python
import dataclasses

@dataclasses.dataclass
class Point:
    x: int
    y: int = 0
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

Unlike with tuples, assignment is allowed:

```py
point.x = 42
```


## Summary

Named tuples are custom tuple types.
This custom type allows member access by field name and by index:

```py
# Since Python 3
import collections

typename = 'Point'
field_names = ('x', 'y')
Point = collections.namedtuple(typename, field_names)

point = Point(x=0, y=1)

point.x
point.y

point[0]
point[1]

# Error - tuples are immutable
# point.x = 7
# point[0] = 7
```

Alternatively, create a named tuple using the `typing` module:

```py
# Since Python 3.6
import typing

class Point(typing.NamedTuple):
    x: int
    y: int = 0

point = Point(x=0, y=1)

point.x
point.y

point[0]
point[1]

# Error - tuples are immutable
# point.x = 7
# point[0] = 7
```

A similar but distinct object is available in the `dataclass` module:

```py
import dataclasses

@dataclasses.dataclass
class Point():
    x: int
    y: int = 0

point = Point(x=0, y=1)

point.x
point.y

# Error - subscripting is not allowed
# point[0]
# point[1]

# Assignment is allowed
point.x = 7
```


## Further Reading

Python3 docs for:

  * [`collections.namedtuple`](https://docs.python.org/3/library/collections.html#collections.namedtuple)
  * [`typing.NamedTuple`](https://docs.python.org/3/library/typing.html#typing.NamedTuple)
  * [`dataclasses.dataclass`](https://docs.python.org/3/library/dataclasses.html#dataclasses.dataclass)

See also:

  * [Named tuples on Stack Overflow](https://stackoverflow.com/questions/2970608/what-are-named-tuples-in-python)
  * [Typed named tuples on Stack Overflow](https://stackoverflow.com/questions/34269772/type-hints-in-namedtuple/34269877)
  * [Gist on Named Tuples](https://gist.github.com/andilabs/15002176b2bda786b9037077fa06cc71)
  * [Docs from the `attrs` package](http://www.attrs.org/en/stable/why.html#namedtuples)
