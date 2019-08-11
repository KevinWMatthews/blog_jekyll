---
title: &title "Lambdas in Python"
permalink: /lambdas-in-python/
excerpt: "Create small anonymous functions using the lambda keyword"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - python
tags:
  - python
  - lambdas
---

Create anonymous functions using the `lambda` keyword.
Similar to Ruby's blocks, etc.
JavaScript has this, too.

## Source

Find [source code](https://github.com/KevinWMatthews/python-lambdas) on GitHub.


## Syntax

The Python language defines the [`lambda` expression](https://docs.python.org/3/reference/expressions.html#lambda):

```py
lambda <parameters>: <expression>
```

This is equivalent to creating:

```py
def <lambda>(parameters):
    return <expression>
```

For example,

```py
lambda x: x * 2
```

This lambda:

  * accepts a single argument (`x`)
  * evaluates the expression (`x * 2`)
  * returns the value of the expression

Lambdas can be stored in a variable and invoked later just like a function:

```py
>>> double_it = lambda x: x * 2
>>> double_it(2)
4
>>> double_it(3)
6
```

Lamdas may also be passed directly into a function:

```py
def accepts_a_function_object(function_object):
    function_object()

accepts_a_function_object(lambda: print("In the lambda"))
```

Python will automatically bind the lambda to the argument.


### Multi-line Lambdas

Lambdas may *not* be multi-line!
This is a language design decision; see [Guido's blog post](https://www.artima.com/weblogs/viewpost.jsp?thread=147358).
If you need a multi-line lambda, he recommends using a "named function nested in the current scope".


### With the `return` keyword

Lambdas *may not* return a value!
This is by design - lambdas automatically evaluate and return their expression.


## Examples

### No Arguments

```py
>>> the_lambda = lambda: 42
>>> the_lambda()
42
```


### One Argument

```py
>>> the_lambda = lambda x: x
>>> the_lambda(42)
42
```


### Two Arguments

```py
>>> the_lambda = lambda x, y: x + y
>>> the_lambda(41, 1)
42
```


## Further Reading

  * Python [language docs](https://docs.python.org/3/reference/expressions.html#lambda)
  * [How-to](http://book.pythontips.com/en/latest/lambdas.html)
  * Guido on [multi-line lambdas](https://www.artima.com/weblogs/viewpost.jsp?thread=147358)
  * Stack Overflow on multi-line lambdas, answered [here](https://stackoverflow.com/questions/1233448/no-multiline-lambda-in-python-why-not/1233520#1233520) and [here](https://stackoverflow.com/questions/1233448/no-multiline-lambda-in-python-why-not/26210269#26210269)
  * Failed proposal for [Ruby-style blocks](http://tav.espians.com/ruby-style-blocks-in-python.html)
