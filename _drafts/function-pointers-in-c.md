---
title: &title Function Pointers in C
permalink: /funtion-pointers-in-c/
toc_label: *title
toc: true
toc_sticky: true
categories:
  - c
tags:
  - c
---

Syntax cheatsheet for function pointers.

Find source code and documentation
[on GitHub](https://github.com/KevinWMatthews/c-function_pointers).


## Introduction

Function pointers are one of the few methods that C provides for indirection.
They can be used for dependency injection/inversion.


## Basic Syntax

The syntax for function pointers can obscure but it is based directly on the
usual syntax for functions.

Functions in C are defined as:
```c
return_value function_name(parameter_list)
```

while function pointers use:
```c
return_value (*function_name)(parameter_list)
```

There are two additions, both required:

  * Pointer operator `*`
  * Parentheses `()`

The parentheses are for scope - they prevent the pointer operator from being
associated with the return type.

An example declaration is:
```c
int actual_function(char parameter)

int (*function_pointer)(char parameter)
```

The mechanism is simple: wrap the function name in parentheses, then add a star
inside the parentheses to create a pointer.


### In Declarations

Function pointer declarations can cause extra confusion because the function name,
like a parameter name, is optional:
```c
// Parameter name omitted
int actual_function(char);

// Function name and parameter name omitted
int (*)(char);
```

This technique is often used in header files and
API documentation.


### With Pointer Argument Types

A function can also accept a pointer as a parameter, so function pointers
can also:

```c
int actual_function(char *parameter);

int (*function_pointer)(char *parameter);
```


### With Pointer Return Types

Functions can also return pointers. This is why parentheses are required - they distinguish between the two `*` operators:
```c
// Returns a pointer to an int
int *actual_function(void);

// Function pointer; function returns a pointer to an int
int *(*function_pointer)(void);
```

The substitution is still the same: wrap the function name in parentheses,
then add a star inside the parentheses.

### With Pointer Argument and Return Types

More stars, you say? Functions can both accept and return pointers, leading
to a small army of stars:

```c
int *actual_function(char *parameter);

int *(*function_pointer)(char *parameter);
```

This example:
  * accepts a `char *`
  * returns an `int *`


### Void Pointers

Using `void` pointers can seem more obtuse, but the syntax is similar:

```c
void *actual_function(void *paramter)

void *(*function_pointer)(void *parameter)
```

These:
  * accept a void pointer
  * return a void pointer

And, of course, the latter is a pointer itself (a function pointer).


## Example

The Linux `pthread` library provides a real-world example of function pointers,
namely the  `start_routine`
parameter of
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
So many stars!

The key to deciphering this is to start reading at the most deeply nested
parentheses and read outward.
