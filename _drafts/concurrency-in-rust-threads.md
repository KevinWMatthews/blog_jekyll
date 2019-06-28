---
title: &title "Concurrency in Rust: Threads"
permalink: /concurrency-in-rust-std-thread/
excerpt: "Part 1: Using Threads From the Standard Library"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - rust
tags:
  - rust-concurrency
  - rust
  - concurrency
  - threads
---

## Source

TODO point to example on GitHub.

Add note on running: use `--bin=` option.


## Background

TODO


## Syntax


### Closure-based

Based on closures. No really - `thread::spawn()` seems to require a closure
right there!
Can also pass a function or a closure that is stored in a variable, but this still may be based on captures!

I think that this built-in closure can not receive arguments.

If we put a closure in a variable and capture it, we can call the closure
with an argument.

See `syntax.rs`.


### Capture

What's with the Copy trait?


### Mutable Capture

The behavior seems to differ slightly from closures -
the thread knows to mutably capture?
