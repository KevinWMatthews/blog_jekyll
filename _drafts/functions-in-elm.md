---
title: &title "Functions in Elm"
permalink: /functions-in-elm/
excerpt: "An introduction to functions in Elm"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - elm
tags:
  - elm
  - functions
---

A beginner's guide to functions in Elm, a statically typed functional language.


## Type Annotations for Functions

Elm allows you give a "type annotation" to explicitly define the types that a function will use.

Shortcut:

  * functions always return a value
  * the last type in an annotation is the return value
  * all previous types are arguments


### With No Arguments

Separate the function name and the list of types (called?) with a colon (`:`):

```elm
-- No arguments, return value
name : type
```

For example,

```elm
the_meaning : Int
```

This function:

  * is named `the_meaning`
  * accepts no arguments
  * returns an `Int`.

The last type in a type annotation is the return value.

This function is indistinguishable from a variable?

Functions in Elm always return a value!


### With One Argument

To annotate a function with a single argument and a return a value,
use an arrow (`->`) to separate the argument type from the return type:

```elm
-- One argument:
name : type -> type
```

For example,

```elm
double_it : Int -> Int
```

This function:

  * is named `double_it`
  * accepts an `Int`
  * returns an `Int`


### With Multiple Arguments

To annotate a function that accepts two arguments, it's useful to think about [partial application](#partial-application).
In short, the last type is the return value; all previous types are arguments.

```elm
-- Two arguments:
name : type -> type -> type

-- Three arguments:
name : type -> type -> type -> type
```

For example:

```elm
sum_of_squares : Int -> Int -> Int
is_pythagorean : Int -> Int -> Int -> Bool
```


## Function Definitions

TODO Is it actually called a function definition?


### With No Arguments

Separate the function name and function body with an equals sign (`=`):

```elm
the_meaning : Int
the_meaning = 42
```

TODO Functions in Elm return the value of the last expression?

Examining this function in `elm repl` gives:

```elm
> the_meaning
42 : number
```

A function with no arguments is indistinguishable from a variable!


### With One Argument

Give the name of the argument before the `=`:

```elm
square_it : Int -> Int
square_it a =
    a ^ 2
```

Again, functions in Elm return the value of the last expression, in this case `a ^ 2`.

`elm repl` gives:

```elm
> square_it
<function> : number -> number
```

If this function is given an argument, it returns a number:

```elm
> square_it 3
9 : number
```


### With Multiple Arguments

Give the names of all arguments before the `=`:

```elm
sum_of_squares : Int -> Int -> Int
sum_of_squares a b =
    a^2 + b^2
```

In `elm repl`, for example:

```elm
> sum_of_squares
<function> : number -> number -> number
```

Using it:

```elm
> sum_of_squares 1 2
5 : number
```

A function with three arguments is similar:

```elm
is_pythagorean a b c =
    a^2 + b^2 == c^2
```

From `elm repl`:

```elm
> is_pythagorean
<function> : number -> number -> number -> Bool
```

Using this, for example:

```elm
> is_pythagorean 1 2 3
False : Bool

> is_pythagorean 3 4 5
True: Bool
```


## Partial Application

Partial application, related to currying (named after Haskell Curry),
is a feature that is common to functional languages.

TODO figure out what these things mean.

It has its roots in mathematics but may be easiest to understand from examples.

Conceptually, every function in Elm accepts *only one argument*.
Functions with multiple arguments actually return another function.


### Funcion with No Arguments

Does not apply?


### Function with One Arguments

Does not apply?


### Functions with Multiple Arguments

Recall from earlier:

```elm
sum_of_squares : Int -> Int -> Int
sum_of_squares a b =
    a^2 + b^2
```

This is equivalent to:

```elm
sum_of_squares : Int -> (Int -> Int)
```

that is, a function that accepts an int argument and returns a function!
Specifically, it reutrns a function that:

  * accepts an `Int`
  * returns an `Int`

To explore this in practice, pass the original function just a single argument:

```elm
> sum_of_squares 1
<function> : number -> number
```

This returns a function!

Internally, Elm has evaluated `sum_of_squares` with `a = 1`.
There is still an undefined variable, so Elm returns a function that is equivalent to:

```elm
1^2 + b
```

This function can be stored in a variable:

```elm
> sum_with_one_squared = sum_of_squares 1
<function> : number -> number
```

Elm essentialy gives us this new function for free:

```elm
sum_with_one_squared : Int -> Int
sum_with_one_squared b =
    1^2 + b
```

This can be used like this:

```elm
-- Store new function
> sum_with_one_squared = sum_of_squares 1
-- Use it
> sum_with_one_squared 2
5 : number
```


### Example

Here is an example with three arguments:

```elm
is_pythagorean : Int -> (Int -> Int -> Bool)
is_pythagorean =
    a^2 + b^2 == c^2
```

can be used as:

```elm
> first_application = is_pythagorean 3
<function> : number -> number -> Bool
```

which conceptually is:

```elm
first_application : Int -> (Int -> Bool)
first_application =
    3^2 + b^2 == c^2
```

Continuing,

```elm
> second_application = first_application 4
<function> : number -> Bool
```

and conceptually:

```elm
second_application : Int -> Bool
second_application =
    3^2 + 4^2 == c^2
```

And finally,

```elm
> third_application 5
True : Bool
```

which conceptually is:

```elm
third_application : Bool
third_application =
    3^2 + 4^2 == 5^2
```

Neat!


## Summary

The typical syntax for Elm functions is, colloquially:

```elm
name : type_a -> type_b -> type_r   -- type annotation
name a b =                          -- function definition
    r
```

The last type in the type annotation denotes the type of the return value.
All previous types denote arguments.

For example:

```elm
-- no arguments, returns Bool
-- a variable, really
no_arg : Bool
no_arg =
    True

-- one Int argument, returns Bool
one_arg : Int -> Bool
one_arg a b =
    True

-- two Int arguments, returns Bool
two_args : Int -> Int -> Bool
two_args a b =
    True

-- three Int arguments, returns Bool
three_args : Int -> Int -> Int -> Bool
three_args a b c =
    True

-- and so on
```


## Further Reading

Introduction to functions:

  * Elm Guide on [functions](https://guide.elm-lang.org/core_language.html). See the section "Functions".
  * Elm Guide on [reading types](https://guide.elm-lang.org/types/reading_types.html). See the sections "Functions" and "Type Annotations"

Partial application:

  * Elm Guide on [function types](https://guide.elm-lang.org/appendix/function_types.html)
  * Stack Overflow on [currying vs partial application](https://stackoverflow.com/questions/218025/what-is-the-difference-between-currying-and-partial-application)
