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
for all examples on GitHub.

## Syntax

### Using Typedef Syntax

Typedefs provide the most straightforward experience.

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

New variables can be declared as follows:
```c
STRUCTURE structure = {
  .function_pointer = NULL
};
```

Of course, you'll typically want the function pointer to refer to somethign useful:
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


### With Argument and Return Value

TODO ?


### Using Traditional Syntax

Some libraries do not use typedef syntax but instead refer to each function pointer
in full. This is more complex but has the same effect:
```c
typedef struct STRUCTURE
{
  // The struct element name is within the parenthesis
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

TODO


## Summary

TODO
