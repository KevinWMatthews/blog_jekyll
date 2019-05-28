---
title: &title "Function Pointers in C: As Function Parameters"
permalink: /function-pointers-in-c-as-function-parameters/
excerpt: "Part 3: Passing function pointers to functions in C."
toc: true
toc_label: *title
toc_sticky: true
categories:
  - c
tags:
  - c
  - function-pointers
---


## Source

This is the third in a
[series on function pointers](/tags/#function-pointers) in C.
Find [source code](https://github.com/KevinWMatthews/c-function_pointers)
and [documentation](https://kevinwmatthews.github.io/c-function_pointers/)
for all examples on GitHub.


## Syntax

Function pointers can be passed to a function much like any other variable type.
This can be done in a few different ways, but we'll start with typedef syntax as
it tends to make the function signature less verbose.


### Using Typedef Syntax

Use the `typedef` keyword to create a custom type alias:
```c
typedef void (*FUNCTION_POINTER)(void);

// Function that accepts a function pointer as an argument
void calls_function_pointer(FUNCTION_POINTER function_pointer);
```

Note that we don't need to add a `*` to the function signature because
the custom type `FUNCTION_POINTER` captures this.

We can fill out the definition of the function like this:
```c
typedef void (*FUNCTION_POINTER)(void);

void calls_function_pointer(FUNCTION_POINTER function_pointer)
{
  if (function_pointer)
    function_pointer();
}
```

Note that we validate the function pointer manually before calling it.
This is because we want to be able to pass `NULL` safely:
```c
calls_function_pointer(NULL);   // should not segfault!
```

Let's declare the behavior that we actually want to pass:
```c
void pass_this_function(void)
{
  // ...
}
```

This can be passed to a function as follows:
```c
calls_function_pointer(pass_this_function);
```

The compiler treats `pass_this_function` as a function pointer.


### Function Pointers with Arguments

If the function pointer accepts an argument, the calling function must provide it:
```c
typedef void (*FUNCTION_POINTER)(char);

void calls_function_pointer(FUNCTION_POINTER function_pointer)
{
  if (function_pointer)
    function_pointer('c');
}
```
If the argument is not provided, compilation will fail:
```
error: too few arguments to function ‘function_pointer’
         function_pointer();
```


### Function Pointers In a Variable

We aren't limited to passing functions directly. We can store a function
pointer in a variable and then pass this variable to a function:

```c
FUNCTION_POINTER variable = pass_this_function;
calls_function_pointer(variable);
```



### Using Traditional Syntax

Some libraries do not use typedef syntax for function pointers, opting instead for
the more verbose traditional syntax. This works in the same way:
```c
void calls_function_pointer(void (*function_pointer)(void))
{
  if (function_pointer)
    function_pointer();
}
```
The parameter of `calls_function_pointer` is a pointer to a function
- note the `(*)`. This function pointer accepts a `void` parameter and returns `void`.

We can define and execute the remainder of the example similarly:
```c
void pass_this_function(void)
{
  // ...
}

calls_function_pointer(pass_this_function);
```

A function pointer can still be stored in a variable:
```c
void (*variable)(void) = pass_this_function;
calls_function_pointer(variable);
```
Only the variable type is more complex.



## Summary

Typedef syntax is the most straightforward:
```c
typedef void (*FUNCTION_POINTER)(void);

void calls_function_pointer(FUNCTION_POINTER function_pointer)
{
  if (function_pointer)
    function_pointer();
}

void pass_this_function(void)
{
  // ...
}

calls_function_pointer(pass_this_function);
```

Traditional syntax is more verbose but equally effective:
```c
void calls_function_pointer(void (*function_pointer)(void))
{
  if (function_pointer)
    function_pointer();
}

void pass_this_function(void)
{
  // ...
}

calls_function_pointer(pass_this_function);
```
