---
title: &title "Dependency Injection in C"
permalink: /dependency-injection-in-c/
excerpt: "Managing Dependencies using function pointers"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - c
tags:
  - c
  - dependency-injection
  - dependency-management
---

## Background

All we really have is function pointers.
Link to articles here. (which articles?)

Problem:

  * Main app needs module behavior to change at runtime
  * Different main apps need different behavior (at compile time)
    - Should we show an example of this?

Symptoms:
  * Growing switch statements.
  * `if`s or `#ifdef`s to distinguish between executables

Solution:
  * dependency injection (function pointers)
  * dependency injection or conditional compilation (not shown here)


## Dependency Injection

An isolated example of how dependency injection works in C.

A function, `generic_routine()` accepts a pointer to a function.
It calls the function pointer, executing whatever behavior it was given
*without knowing* any details.

The higher level logic (here `main`) selects the appropriate behavior.

This makes it easier to configure, modify, maintain, and see business logic.


## Solutions

Let's examine how design can evolve.


### Monolith

For single applications, dependency injection may not be necessary. This can
especially be true if an application is small. If all code is in one file,
there's nothing wrong with changing that file!

Here we read a command from the user, then use a `switch` statement to
decide which specific behavior to execute.

Clean, easy, straightforward.

This structure becomes more complex as applications begin to scale.


### Module with Switch Statement

Let's say that the application has evolved - we now need to execute some
complex routine before and after our `specific_behavior`. For clarity, this
is extracted into a module.

`main()` now looks very clean - read input, execute a command. The complexity
is hidden away inside the module and we are exposed to it only when we need to be.

Again, this is a decent architecture for some situations. If it makes sense for
the module to know about each specific behavior (and how to parse commands
from the user), then this is fine.

Frequently, however, this isn't the case. What if the first behavior, say,
starts an animation while the second behavior interacts with hardware? Now the
module will depend on vastly different things, say GTK and a hardware layer.
Further, if we add a third behavior, the module (and everything that uses it)
must know.

In this case, you can see a dependency on `<stdio.h>`.

(Create a graphic).

Beyond this, what if different executables use the module? The situation grows more complex.

What if an application needs different behavior for a command? Now we need to
introduce conditional compilation, dive down into the module, and be aware of
both programs while we make our changes.

What if an application doesn't even use a command? It still must compile all of
the module's dependencies. It's entirely possible for an application to be forced
to compile, say, a graphics library that it doesn't use.

(Create another graphic).

This is hard to maintain.

### Module with Dependency Injection

Function pointers can be used to solve this problem.

Each application maps commands to its own specific behaviors, selecting and
configuring only what it needs.


### Multiple Applications

Talk about the example?


## Summary

Be aware of the design as requirements evolve!
If changes are becoming difficult - switch statements are multiplying, for example -
then reconsider the design. A few diagrams and choice refactoring can save
hours of frustration.

Each design has its place in the life cycle of a product. Don't be afraid to change!

If you make and document clear design decisions, you can refer to them later
and choose an appropriate design for a new set of requriements.

Business value - software should be soft. Don't complain that "sales keeps changing
things"; this may well be the primary value in your business.
