---
title: &title "Function Pointers in C: Typedef Syntax"
permalink: /funtion-pointers-in-c-typedef-syntax/
excerpt: "Type alias for function pointers in C using the typedef keyword.
Function pointers, part 2."
toc: true
toc_label: *title
toc_sticky: true
categories:
  - c
tags:
  - c
  - function-pointers
---

Sure, function pointers are powerful, but the syntax... so much noise!
Wouldn't it be nice if you could store a function pointer in a variable but
only use a single specifier, just like any other type?
The `typedef` keyword lets you do just that. Use it to
define the function pointer details once, hide them behind an alias, and
then use this alias like a built-in type.


## Source

This is the second in a series on function pointers in C.
Find [source code](https://github.com/KevinWMatthews/c-function_pointers)
and [documentation](https://kevinwmatthews.github.io/c-function_pointers/)
for all examples on GitHub.


## Syntax

### Typedef for Variables

First a refresher on creating a type alias for a built-in type:
```c
typedef int CUSTOM_TYPE;
```

This creates a synonym (often called an alias) `CUSTOM_TYPE` that can be used in
place of the traditional type specifier `int`:
```c
CUSTOM_TYPE the_meaning = 42;
// is equivalent to
int the_meaning = 42;
```

Here I'm using screaming snake case (all caps with underscores), but this is
a personal convention; choose what suits you.


### Typedef for Function Pointers

Type aliases for function pointers use a somewhat different syntax:
```c
typedef return_value (*CUSTOM_TYPE)(parameter_list);
```

The name of the new alias is in the middle of the `typedef` statement, not at the
end. As with [function pointers](/funtion-pointers-in-c-basic-syntax/),
the `*` operator must be enclosed in parentheses
to prevent it from applying to the return value.

Here is a specific example:
```c
typedef int (*FUNCTION_POINTER)(char);
```


## Function Pointers as Variables

A type alias for a function pointer can be used much like a built-in type:
```c
typedef int (*FUNCTION_POINTER)(char);

int some_actual_function(char *character)
{
    // Function body here
}

FUNCTION_POINTER function_pointer = some_actual_function;
```

There is no need to use a `&` operator in the assignment.

This is straightforward when compared to the standard syntax:
```c
int (*function_pointer)(char) = some_actual_function;
```


## Calling Function Pointers

The function can be called quite easily using the pointer:
```c
typedef int (*FUNCTION_POINTER)(char character);

/* snip */

FUNCTION_POINTER function_pointer = some_actual_function;

int result = function_pointer('c');
```

This calls `some_actual_function` with a single argument, `'c'`, and
stores the return value in `result`.

As with all pointers, be sure to check for `NULL` to prevent segfaults:

```c
if (function_pointer)
    function_pointer();
```


## Real-world Example

The standard library seems to avoid type aliases for function pointers but has
used them for complex situations. One example is the (historical) function
[signal](http://man7.org/linux/man-pages/man2/signal.2.html):

```c
typedef void (*sighandler_t)(int);
sighandler_t signal(int signum, sighandler_t handler);
```

This declares a type alias `sighandler_t` for a function that accepts an `int`
and returns `void`. The `signal` function both accepts and returns this type.

Without the typedef, this becomes throughly obtuse:
```c
void ( *signal(int signum, void (*handler)(int)) ) (int)
```

The conversion between the two is left as an exercise to the reader....

Interestingly, attempting to define a function with the non-`typedef` form
results in a compiler error on gcc:
```c
void signal(int signum, void (*handler)(int)) (int)
{
    // Function body here
}
```
```
error: ‘signal’ declared as function returning a function
void signal(int signum, void (*handler)(int)) (int)
     ^
```

and on clang:
```
error: function cannot return function type 'void (int)'
void signal(int signum, void (*handler)(int)) (int)
           ^
1 error generated.
```

C functions can't return an *actual function*, though they can return a pointer
to a function (an address in memory).

But enough with `signal`; the docs recommend to use
[sigaction](http://man7.org/linux/man-pages/man2/sigaction.2.html)
instead. Take a look at this for some examples of traditional function pointer
syntax.


## Summary

Using a `typedef` for function pointers allows you to treat function pointers
much like built-in types:
```c
typedef void (*FUNCTION_POINTER)(void);
FUNCTION_POINTER function_pointer = /* actual function name */;
if (function_pointer)
    function_pointer();
```

This is a powerful and straightforward way to store and execute generic behavior.
Of course, don't forget to check for `NULL`!
