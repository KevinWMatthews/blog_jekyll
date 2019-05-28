---
title: &title "Function Pointers in C: Basic Syntax"
permalink: /funtion-pointers-in-c-basic-syntax/
excerpt: "Part 1: Introduction to function pointer syntax in C."
toc: true
toc_label: *title
toc_sticky: true
categories:
  - c
tags:
  - c
  - function-pointers
---

Function pointers are one of the few mechanisms that C provides for executing
generic behavior. They can be used to implement dependency injection and
can be a powerful tool for managing dependencies within a project.


## Source

This is the first in a
[series on function pointers](/tags/#function-pointers) in C.
Find [source code](https://github.com/KevinWMatthews/c-function_pointers)
and [documentation](https://kevinwmatthews.github.io/c-function_pointers/)
for all examples on GitHub.


## Syntax

The syntax for function pointers can obscure but it is based directly on the
usual syntax for functions.

Functions in C are declared with:
```c
return_value function_name(parameter_list)
```

while function pointers use:
```c
return_value (*function_pointer_name)(parameter_list)
```

There are two additions, both required:

  * Pointer operator `*`
  * Parentheses `()`

The parentheses are for scope - they prevent the pointer operator from being
associated with the return type.

An example declaration is:
```c
void actual_function(void)

void (*function_pointer)(void)
```

The conversion mechanism is simple: wrap the function name in parentheses,
then add a star inside the parentheses (before the name) to create a pointer.

Recognizing function pointers is a skill in its own right. They always follow
the same pattern, which you can learn to recognize:

```c
// Neighboring parentheses with a pointer in the first pair
(*)()
```

If you notice this, look for a return value and parameter list; you likely
are looking at a pointer to a function.

Keep in mind the trick for reading C in general: find the most deeply nested set
of parentheses, then work outward from there.


### With Argument and Return Value

Function pointers can accept arguments and return a useful value:

```c
int actual_function(char parameter)

int (*function_pointer)(char parameter)
```

Both the function and function pointer:
  * accept a `char`
  * return an `int`



### With Pointer Argument Types

A function can also accept a pointer as a parameter:

```c
int actual_function(char *parameter)

int (*function_pointer)(char *parameter)
```

Both the function and function pointer
  * accept a `char *`
  * return an `int`


### With Pointer Return Types

Functions can also return pointers. This is why parentheses are required around
the function pointer name - they distinguish between the two `*` operators:
```c
// Returns a pointer to an int
int *actual_function(void)

// Function pointer; function returns a pointer to an int
int *(*function_pointer)(void)
```

These:
  * accept `void` (no parameters)
  * return an `int *`

The substitution is still the same: wrap the function name in parentheses,
then add a star inside the parentheses.


### With Pointer Argument and Return Types

More stars, you say? Functions can both accept and return pointers, leading
to a small army of stars:

```c
int *actual_function(char *parameter)

int *(*function_pointer)(char *parameter)
```

These:
  * accept a `char *`
  * return an `int *`


### With Void Pointers

Using `void` pointers can seem more obtuse, but the syntax is similar:

```c
void *actual_function(void *paramter)

void *(*function_pointer)(void *parameter)
```

These:
  * accept a `void *`
  * return a `void *`


### With Names Omitted

Function pointer declarations can be confusing because the function name,
like a parameter name, is optional:
```c
// Parameter name omitted
int actual_function(char);

// Function name and parameter name omitted
int (*)(char);
```

This technique is often used in header files and
API documentation.


## Function Pointers as Variables

Function pointers can be declared like variables:
```c
int (*function_pointer)(char) = NULL;
```

This creates a variable, `function_pointer`, that can store the address of an
actual function (or `NULL`).

The function signatures must match! In this case, you should only assign a
function that accepts a `char` and returns an `int`. Doing otherwise results
in a compiler warning and could lead to undefined behavior. Heed the
compiler's warnings!

Here is an example of an assignment:
```c
int actual_function(char *character)
{
    // Do stuff...
}

int (*function_pointer)(char) = actual_function;
```

This creates a variable `function_pointer` and stores the address of
`actual_function` in it.

There is no need to use an `&` (address of) operator in the assignment -- C
automatically uses the address of `actual_function`.


## Calling Function Pointers

Function pointers can be called just like any other function:
```c
/* snip */

int (*function_pointer)(char) = actual_function;

function_pointer();
```

There is no need to dereference the function pointer using `(*)`:
```c
// Unneeded dereference
(*function_pointer)();
```
C handles the dereferencing automagically. In fact, C seems to do this for all
function calls; the standard implies that normal 'function designators' are
converted to function pointers behind the scenes before the `()` operator
is applied. But I digress -- those details aren't important here.

Call a function pointer as you would call an actual function,
but don't forget to check for `NULL`:

```c
if (function_pointer)
    function_pointer();
```

Alternatively, use:
```c
if (function_pointer != NULL)
    function_pointer();
```


## Real-World Example

The Linux `pthread` library provides a real-world example of function pointers.
Let's examine the `start_routine` parameter of
[pthread_create()](http://man7.org/linux/man-pages/man3/pthread_create.3.html):
```c
void *(*start_routine) (void *)
```

This function pointer:
  * is named `start_routine`
  * accepts a void pointer (parameter name omitted)
  * returns a void pointer

This is just one of the parameters. The entire declaration is:
```c
int pthread_create(pthread_t *thread,
    const pthread_attr_t *attr,
    void *(*start_routine) (void *),  // <-- This one
    void *arg);
```
Read closely!


## Summary

Function pointer syntax is based on a pattern:
```c
(*)()
```

Learn to recognize:
  * neighboring parentheses
  * a pointer in the first pair

This pattern is expanded to:
```c
// In general
return_value (*function_pointer_name)(parameter_list)

// Specific example
void (*function_pointer_name)(void)
```

Remember the trick for reading C: start at the most deeply nested
parentheses and work outward.


Here is an example:
```c
// Define a function
void actual_function(void)
{
    // ...
}

// Initialize a function pointer variable
void (*function_pointer)(void) = actual_function;

// Call the function through the pointer
if (function_pointer)
    function_pointer();
```

As always, don't forget to check for `NULL`!
