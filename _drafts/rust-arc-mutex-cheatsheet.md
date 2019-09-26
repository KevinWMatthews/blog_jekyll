---
title: &title "Rust Arc/Mutex Cheat Sheet"
permalink: /rust-arc-mutex-cheatsheet/
excerpt: "Quickstart for Atomically Reference Counted variables and Mutexes in Rust"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - rust
tags:
  - rust
  - arcs
  - cheatsheet
---

Reference for Rust `Arc` syntax and how the wrap `Mutex`es.


## Source

Find [source code](https://github.com/KevinWMatthews/rust-arcs_and_mutexes) on GitHub.


## Background

`Mutex`es are used to safely share data between threads.
Both the shared data and the mutex itself typically live outside of the threads that use them, so either the mutex or the data could go out of scope and be deallocated while they are still being used.
To prevent this, wrap the `Mutex` in a reference counted type.
This keeps dynamically allocated memory in scope until the last reference to it is deallocated.

Rust provides a basic reference counted type, `Rc`, but this is not thread safe.
Operations are non-atomic under the hood, so there is room for race conditions.
Rust also provides a thread-safe referenced counted type, `Arc` (atomically reference counted).


## Syntax

Declare shared data:

```rust
let arc = Arc::new(Mutex::new(42));
```

The `Arc` itself can not be shared between threads, but clones (counted references?) of an `Arc` can:

```rust
let cloned = Arc::clone(&arc);
```

Then *move* the clone into the thread:

```rust
let handle = thread::spawn(move || {
    // ...
});
```

Note the `move` keyword on the closure;
this forces the thread to own references and avoid lifetime issues.

Accessing shared data involves several steps:

  * Dereference the `Arc`, giving a `Mutex`
  * Lock the `Mutex`, giving a `Result`
  * Unwrap the `Result`, giving a `MutexGuard` (scoped lock)
  * Dereference the `MutexGuard`, giving the shared data

```rust
let value = *cloned.lock().unwrap();
```

This can be split over multiple lines, but it is typically best to combine these steps in order to:

  * leverage the `Deref` trait, avoiding explicit borrows
  * unlock/release the mutex as quickly as possible (at the end of the line)

The latter point is subtle - holding on to a `MutexGuard` too long in the context of a loop can cause a deadlock.


## Summary

```rust
use std::sync::{Arc, Mutex};
use std::thread;

let arc = Arc::new(Mutex::new(42));
let cloned = Arc::clone(&arc);
let handle = thread::spawn(move || {
    let value = *cloned.lock().unwrap();
    // ...
});
```


## Links

  * [`Mutex`](https://doc.rust-lang.org/std/sync/struct.Mutex.htm)
  * [`Arc`](https://doc.rust-lang.org/std/sync/struct.Arc.html)
  * [Rust Book](https://doc.rust-lang.org/book/ch16-03-shared-state.html)
