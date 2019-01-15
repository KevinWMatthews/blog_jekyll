---
title: &title "Function Pointers in C: Typedef Syntax"
permalink: /funtion-pointers-in-c-typedef-syntax/
excerpt: "Type alias for function pointers in C using the typedef keyword.
Function pointers, part 2 of 4."
toc_label: *title
toc: true
toc_sticky: true
categories:
  - c
tags:
  - c
  - function-pointers
---

Sure, function pointers are powerful, but the syntax... too much noise!
Wouldn't it be nice if you could store a function pointer in a variable, much
like any other type? The `typedef` keyword lets you do just that. Use it to
specify the ugly function pointer details once, hide it behind an alias, and
then use the alias like a built-in type.

This is the second of a four-part series on function pointers.
Find source code and documentation
[on GitHub](https://github.com/KevinWMatthews/c-function_pointers).


## Syntax

### Typedef for Variables

First a refresher on creating a type alias for a built-in type:
```c
typedef int CUSTOM_TYPE;
```

This creates a new type, `CUSTOM_TYPE`, that can be used in place of a
traditional `int`:
```c
CUSTOM_TYPE the_meaning = 42;
// is equivalent to
int the_meaning = 42;
```

I'm using screaming snake case (caps with underscores), but the case of the
custom type alias is conventional; choose what suits you.

### Typedef for Function Pointers

Type aliases for function pointers use a somewhat different syntax:
```c
typedef return_value (*CUSTOM_TYPE)(parameter_list);
```

The name of the new type is in the middle of the `typedef` statement, not at the
end.

Here is a specific example:
```c
typedef int (*FUNCTION_POINTER)(char *string);
```

This new type, `FUNCTION_POINTER`, can be used much like a built-in type:
```c
FUNCTION_POINTER function_pointer = some_actual_function;
```

This is straightforward when compared to the standard syntax:
```c
int (*function_pointer)(char *) = some_actual_function;
```


### Calling the Function

The function can be called quite easily using the pointer:
```c
typedef int (*FUNCTION_POINTER)(char *string);

FUNCTION_POINTER function_pointer = /* some_actual_function */;

int result = function_pointer("A string");
```

This calls `some_actual_function` with a single argument, `"A string"`, and
stores the return value in `result`.


## Real-world Example

The standard library seems to avoid type aliases for function pointers but has
used them for complex situaitons. One example is the (historical) function
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

Interestingly, attempting to define a function with this form results in a
compiler error on gcc:
```c
void signal(int signum, void (*handler)(int))
{
  // Function body here
}
```
```
error: ‘signal’ declared as function returning a function
```

But enough with `signal`; the docs recommend to use
[sigaction](http://man7.org/linux/man-pages/man2/sigaction.2.html)
instead. Take a look for some examples of traditional function pointer syntax.

## Summary

Using a `typedef` for function pointers allows you to tread function pointers
similar to built-in types:
```c
typedef void (*FUNCTION_POINTER)(void);
FUNCTION_POINTER function_pointer = /* actual_function */;
if (function_pointer)
    function_pointer();
```

This is an powerful and straightforward way to store and execute generic behavior.
Of course, don't forget to check for `NULL`!
