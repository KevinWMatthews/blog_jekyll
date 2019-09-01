---
title: &title "Pattern Matching in Rust"
permalink: /pattern-matching-in-rust/
excerpt: "Match statements on Copy types, non-Copy types, and references to both"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - rust
tags:
  - rust
  - matching
---

An introduction to the complexities of pattern matching in Rust.

Explores the differences between matching `Copy` types, non-`Copy` types,
references, and how Rust's match ergonomics affects these.


## Source

Find [source code](https://github.com/KevinWMatthews/rust-pattern-matching) on GitHub.


## Copy Types

Copy types are easy to match.
They are on the stack and can always be copied, so ownership is not a concern.


### Copy

Here is an example of matching a `Some` type in an `Option`:

```rust
let maybe_number = Some(42);
match maybe_number {
    Some(x) => println!("Found a specific value: {}", x),
    None => println!("Found nothing"),
}
```

and a `None` type in an `Option`:

```rust
// Must specify type - Rust can't deduce a type from None
let maybe_number: Option<i32> = None;
match maybe_number {
    Some(x) => println!("Found a specific value: {}", x),
    None => println!("Found nothing"),
}
```


### Borrow

References can be matched using Rust's match ergonomics:

```rust
let maybe_number = Some(42);
match &maybe_number {
    Some(borrowed) => {
        let x = *borrowed;
        println!("Found something: {}", x);
    },
    None => println!("Found nothing"),
}
```


### Old-style Borrow

Before match ergonomics, one had to explicitly:

  * match against a reference
  * bind the `Option`'s value as a reference using the `ref` keyword

For example:

```rust
let maybe_number = Some(42);
let maybe_number_ref = &maybe_number;
match maybe_number_ref {
    &Some(ref borrowed) => {
        let x = *borrowed;
        println!("Found something: {}", x);
    },
    &None => println!("Found nothing"),
}
```

Alternatively, one could:

  * dereference before matching
  * bind the `Option`'s value as a reference using the `ref` keyword

```rust
let maybe_number = Some(42);
let maybe_number_ref = &maybe_number;
match *maybe_number_ref {
    Some(ref borrowed) => {
        let x = *borrowed;
        println!("Found something: {}", x);
    },
    None => println!("Found nothing"),
}
```


## Non-Copy Types

Ownership is a concern when matching Non-Copy types.
These live on the heap and must either be moved or borrowed.

These examples use a `Box`.


### Move

By default, `match` statements move/own the matched value.

```rust
let maybe_number = Some(Box::new(42));
match maybe_number {
    Some(owns_box) => {
        let x = *owns_box;
        println!("Found something: {}", x);
    },
    None => println!("Found nothing");
}
```

Note that using the value again fails to compile:

```rust
match maybe_number {
    Some(_) => {},
    None => {},
}
```

```
Some(owns_box) => {
     -------- value moved here

match maybe_number {
      ^^^^^^^^^^^^ value used here after partial move
```


### Borrow

The `match` can borrow the matched value instead of owning it.

Using [match ergonomics](https://github.com/rust-lang/rfcs/blob/master/text/2005-match-ergonomics.md),
borrowing can be done simply using the `&` operator:

```rust
match &maybe_number {
    Some(borrows_box) => {
        let x = **borrows_box;
        println!("Found something: {}", x);
    },
    None => println!("Found nothing"),
}
```

This uses a reference match expression (`&maybe_number`) and a non-reference pattern (`Some(borrows_box)`),
so Rust will use match ergonomics to:

  * pattern-match the `Option` as a reference
  * bind the `Option`'s value as a reference

Note the double dereference; the first `*` dereferences the borrow,
the second gets the value out of the `Box` (using the `Deref` trait).

The `Box` is borrowed so we can match again:

```rust
match &maybe_number {
    Some(_) => {},
    None => {},
}
```

Note that the double dereference must be done in-place to avoid a "move out of borrowed content" compiler error:

```rust
match &maybe_number {
    Some(borrows_box) => {
        let the_box = *borrows_box;   // <-- error
        let x = *the_box;
        println!("Found something: {}", x);
    },
    None => println!("Found nothing"),
}
```

This assignment attempts to move the `Box` out of the `Option` and into a new variable.
This is not allowed because the `Option` is borrowed.


### Old-style Borrow

Before match ergonomics, one had to explicitly:

  * match against a reference
  * bind the `Option`'s value as a reference using the `ref` keyword

For example:

```rust
let maybe_number = Some(Box::new(42));
let maybe_number_ref = &maybe_number;

match maybe_number_ref {
    &Some(ref borrows_box) => {
        let x = **borrows_box;
        println!("Found something: {}", x);
    },
    &None => println!("Found nothing"),
}
```

Alternatively, one could:

  * dereference before matching
  * bind the `Option`'s value as a reference using the `ref` keyword

```rust
let maybe_number = Some(Box::new(42));
let maybe_number_ref = &maybe_number;
match *maybe_number_ref {
    Some(ref borrows_box) => {
        let x = **borrows_box;
        println!("Found something: {}", x);
    },
    None => println!("Found nothing"),
}
```


## Further Reading

Rust sources:

  * [RFC 2005](https://github.com/rust-lang/rfcs/blob/master/text/2005-match-ergonomics.md)
  * [Rust by Example](https://doc.rust-lang.org/rust-by-example/flow_control/match.html)
  * [Rust blog](https://blog.rust-lang.org/2017/03/02/lang-ergonomics.html)?

Stack Overflow:

  * [Rust pattern matching](https://stackoverflow.com/questions/56511328/how-does-rust-pattern-matching-determine-if-the-bound-variable-will-be-a-referen)
  * [Rust tuple dereferencing](https://stackoverflow.com/questions/57128842/how-are-tuples-destructured-into-references/57128935#57128935)
