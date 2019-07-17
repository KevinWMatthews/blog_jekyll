---
title: &title "Function Pointers in C: As Struct Elements"
permalink: /function-pointers-in-c-as-struct-elements/
excerpt: "Part 4: Function pointers as struct elements in C"
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

This is the fourth in a
[series on function pointers](/tags/#function-pointers) in C.
Find [source code](https://github.com/KevinWMatthews/c-function_pointers)
and [documentation](https://kevinwmatthews.github.io/c-function_pointers/)
on GitHub.

## Syntax

Function pointers can be stored directly in a struct.
As usual, there are several syntax options available.
We'll start with typedef syntax because it keeps the struct definition simpler.


### Using Typedef Syntax

First define a type for the function pointer:
```c
typedef void (*FUNCTION_POINTER)(void);
```

Then define a struct type:
```c
typedef struct STRUCTURE
{
  FUNCTION_POINTER function_pointer;
} STRUCTURE;
```

New variables can be defined as follows:
```c
STRUCTURE structure = {
  .function_pointer = NULL
};
```

Of course, you'll typically want the function pointer to refer to something useful:
```c
void function(void)
{
  // Do stuff
}

STRUCTURE structure = {
  .function_pointer = function
};
```

The function pointer can then be called using the `()` operator just like any other function:
```c
if (structure.function_pointer)
  structure.function_pointer();
```

As always, be sure to check for NULL!


### With Argument

If the function pointer accepts an argument, the calling function must provide it:
```c
typedef void (*FUNCTION_POINTER)(char);
typedef struct STRUCTURE
{
  FUNCTION_POINTER function_pointer;
} STRUCTURE;

void function(char character)
{
  // something useful
}

STRUCTURE structure = {
  .function_pointer = function
};

structure.function_pointer('c');  // <-- pass an argument
```

Omitting the argument results in a compiler error.


### Using Traditional Syntax

Some libraries do not use typedef syntax but instead refer to each function pointer
in full. This is more complex but has the same effect:
```c
typedef struct STRUCTURE
{
  // The struct element name is within the parenthesis,
  // e.g. (*name)
  void (*function_pointer)(void);
} STRUCTURE;
```

This is used just as with typedef syntax:
```c

void function(void)
{
  // Do stuff
}

STRUCTURE structure = {
  .function_pointer = function
};

if (structure.function_pointer)
  structure.function_pointer();
```

### Real-World Example

The Linux library function [sigaction](http://man7.org/linux/man-pages/man2/sigaction.2.html)
is an example of function pointers in the wild.

```c
struct sigaction {
  void       (*sa_handler)(int);
  void       (*sa_sigaction)(int, siginfo_t *, void *);
  sigset_t   sa_mask;
  int        sa_flags;
  void       (*sa_restorer)(void);
};
```

This structure stores several function pointers:
  * `void (*sa_handler)(int)`
    - element name `sa_handler`
    - accepts an `int`
    - returns `void`
  * `void (*sa_sigaction)(int, siginfo_t *, void *)`
    - element name `sa_sigaction`
    - accepts an `int`, `siginfo_t` pointer, and `void` pointer
    - returns `void`
  * `void (*sa_restorer)(void)`
    - element name `sa_restorer`
    - accepts `void`
    - returns `void`

The struct could be populated something like:
```c
void custom_sigint_handler(int signal_number)
{
  //...
}

struct sigaction = {
  sa_handler = custom_sigint_handler
};
```

After further configuration, this `struct sigaction`
(along with the custom behavior that it stores)
is passed as an argument to the function `sigaction()`.
This allows the system to execute custom user behavior when a signal is received.


## Summary

Typedef syntax allows function pointers to be stored much like a variable:
```c
typedef void (*FUNCTION_POINTER)(void);

typedef struct STRUCTURE
{
  FUNCTION_POINTER function_pointer;
} STRUCTURE;

void function(void)
{
  // ...
}

STRUCTURE structure = {
  .function_pointer = function,
};
structure.function_pointer();
```

Traditional syntax is more verbose:
```c
typedef struct STRUCTURE
{
  void (*function_pointer)(void);
} STRUCTURE;

void function(void)
{
  // ...
}

STRUCTURE structure = {
  .function_pointer = function,
};
structure.function_pointer();
```

Both follow the same pattern - store the function pointer in a structe element,
call the underlying function through the function pointer using `()`.
