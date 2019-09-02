---
title: &title "Closures in Python"
permalink: /closures-in-python/
excerpt: ""
toc: true
toc_label: *title
toc_sticky: true
categories:
  - python
tags:
  - python
  - closures
---

## Source

This is part of a series on [closures](/tags/#closures).
Find [source code]()
and [documentation]() on GitHub.


## Background

Closures are a function bound to its environment.


## Returning Functions

Python allows for the creation of anonymous functions:
```python
def some_function():
  pass
```

Python can actually return a function from a function:
```python
def returns_function():
  def some_function():
    pass

  return some_function
```

Pretty cool!

The return value of `returns_function` can be stored and executed later:
```python
variable_storing_function = returns_function()
variable_storing_function()
```

or it can be executed immediately:
```python
returns_function()()
```


## Returning Functions with Arguments

It is also possible for the function to take an parameter [argument?]:

```python
def returns_function():
  def some_function(param):
    pass
  return some_function
```

This can be stored and executed as before:
```python
variable_storing_function = returns_function()
variable_storing_function(42)
```

or executed immediately:
```python
returns_function()(42)
```


## Functions Bound to Environment

\[This is where closures come in\].

Closures differ from functions in an important respect:
closures fill in missing variables from the environment.
The environment is determined *when the closure is created*.

For example,
```python
def returns_function():

  def some_function():
    return 1 + 2

  return some_function
```

The symbols `1`, `2`, and `+` aren't actually defined within the function.
Python searches for them and finds them in the language itself.

A common way to leverage this is to capture local variables:
```python
def returns_function():
  x = 42

  def some_function():
    return x

  return some_function
```

`some_function` doesn't define `x`, but the environment that `some_function` is
created in does define that. Python stores this environment along with
`some_function` and uses it whenever `some_function` is called:
```python
variable_storing_function = returns_function()
variable_storing_function()
```

Returns:
```
42
```

Cool, eh?

This uses Python's implementation of closures, so it is more accurate to write:
```python
def returns_closure():
  x = 42

  def some_function():
    # x is not bound
    return x

  # Python returns some_function, but first it
  # binds `x` in some_function to the variable found in return_closure.
  # This combination is called a closure.
  return some_function
```



Nice, but who needs 42? Better to let the caller configure the environment:
```python
def returns_closure(x):

  def some_function():
    return x

  return some_function

variable_storing_closure = returns_closure(43)
variable_storing_closure()
```

Output:
```
43
```


## Closures (functions?) with a Arguments

The function can accept a parameter as well as binding to the environment:
```python
def returns_function(x):

  def some_function(y):
    return x + y

  # x is bound at this point
  # y is not yet determined
  return some_function

# Returns a closure with x = 1
variable_storing_closure = returns_closure(1)

# Calls the closure with y = 2
variable_storing_closure(2)
```

Output:
```
3
```


## Immediate Execution

The closure doesn't need to be stored; it can be called immediately:
```python
def returns_function(x):

  def some_function(y):
    return x + y

  # x is bound at this point
  # y is not yet determined
  return some_function

# Returns a closure with x = 1, then calls it (the function?) with y = 2
returns_closure(1)(2)
```

Output:
```
3
```


## Lambdas

What are lambdas? 'Give me a function here.'

`lambda` returns an 'anonymous function'. Rather than defining a function with
a name (such as `some_function`), we can just get the function directly:

```python
variable_storing_function = lambda : 1 + 2
variable_storing_function()
# 42
```

What's going on here?

lambda *arguments* : *function_body*

In the example above, our argument list is empty (weird, isn't it?).

Here is an example with an argument:
```python
variable_storing_function = lambda x : x + 2
variable_storing_function(1)
# 3
```


## Closures Using Lambdas

This simplifies the syntax of closures somewhat:
```python
def returns_closure():
  return lambda : 1 + 2

variable_storing_closure = return_closure()
variable_storing_closure()
# 3
```

Of course, we can pass an argument to the `lambda`:
```python
def returns_closure():
  return lambda y : 1 + y

variable_storing_closure = return_closure()
variable_storing_closure(2)
# 3
```

And we can also add a variable to the environment:
```python
def returns_closure(x):
  # x is supplied by the closure from the environment
  # y is supplied from the function call (later)
  return lambda y: x + y

variable_storing_closure = returns_closure(1)
variable_storing_closure(2)
# 3
```


## Examples


## Resources

  * [Stack Overflow](https://stackoverflow.com/a/36878651/8807809)
 has a very good intro to lambda calculus and closures.
  * [Wikipedia](https://en.wikipedia.org/wiki/Closure_(computer_programming))
  * Python docs?
  * Where else?
