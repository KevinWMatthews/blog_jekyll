---
title: &title "Lifetime Ellision in Rust"
permalink: /lifetime-ellision-in-rust/
excerpt: "How the Rust compiler auto-computes lifetimes"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - rust
tags:
  - rust
  - lifetimes
---


## Lifetime Ellision Rules

From the Rust Book on [lifetime ellision](https://doc.rust-lang.org/book/ch10-03-lifetime-syntax.html#lifetime-elision).

Rust applies three rules when calculating lifetimes for functions:

  * Each parameter that is a reference gets its own lifetime parameter
  * If there is exactly one input lifetime parameter, that lifetime is assigned to all output lifetime parameters
  * If there are multiple input lifetime parameters, but one of them is `&self` or `&mut self` because this is a method, the lifetime of self is assigned to all output lifetime parameters


## Rule 1

> Each parameter that is a reference gets its own lifetime parameter

Consider this function:

```rust
fn function(input1: &str, input2: i32, input3: &str);
```

Two of the three parameters are a reference, so Rust will auto-generate two lifetimes:

```rust
fn function<'a, 'b>(input1: &'a str, input2: i32, input3: &'b str);
```


## Rule 2

> If there is exactly one input lifetime parameter, that lifetime is assigned to all output lifetime parameters

For example, Rust will convert:

```rust
fn function(input: &str) -> &str;
```

into

```rust
fn function<'a>(input: &'a str) -> &'a str;
```


## Rule 3

> If there are multiple input lifetime parameters, but one of them is `&self` or `&mut self` because this is a method, the lifetime of self is assigned to all output lifetime parameters

For example,

```rust
fn function(&self) -> &str;
```

becomes

```rust
fn function<'a>(&'a self) -> &'b str;
```


## Examples

Rule 2 is typically applied on its own?

Rules 1 and 3 are frequently combined.

```rust
fn function(&self, input1: &str, input2: &str) -> &str;
```

becomes:

```rust
fn function<'a, 'b, 'c>(&'a self, input1: &'b str, input2: &'c str) -> &'a str;
```
