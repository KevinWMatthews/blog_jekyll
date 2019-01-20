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

### Using Typedef Syntax

Function pointers parameters are easier to digest when using a custom type alias:
```c
typedef int (*FUNCTION_POINTER)(char);

// Function that accepts a function pointer as an argument
void calling_function(FUNCTION_POINTER function_pointer);
```

Note that we don't need to add a `*` -  the custom type `FUNCTION_POINTER`
captures this.

We can fill out the definition of the function like this:
```c
typedef int (*FUNCTION_POINTER)(char);

void actual_function(FUNCTION_POINTER function_pointer)
{
  if (function_pointer)
    function_pointer();
}
```

How do we call this? We should be able to pass `NULL` safely:
```c
calling_function(NULL);
```

Let's declare the behavior that we actually want to pass around:
```c
int pass_this_function(char character)
{
  // ...
}
```



Call it using:
```c
calling_function(pass_this_function);
```


### Passing a Variable (edit)

We aren't limited to passing function names directly. We can store a function
pointer in a variable and then pass this variable to a function:

```c
FUNCTION_POINTER variable = pass_this_function;
calling_function(variable);
```




### Using Traditional Syntax

Traditional syntax works the same way but is more verbose:
```c
void calling_function(int (*function_pointer)(char))
{
  if (function_pointer)
    function_pointer();
}

int pass_this_function(char character)
{
  // ...
}

calling_function(pass_this_function);
```

You can still store the function pointer in a variable:
```c
int (*variable)(char) = pass_this_function;
calling_function(variable);
```

but the variable type is more complex.



## Summary

Typedef syntax is the most straightforward.
```c
// example
```

Traditional syntax works, too
```c
// example
```
