---
title: &title "Matching in Rust"
permalink: /matching-in-rust/
excerpt: "Getting values out of an Option type"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - rust
tags:
  - rust
  - matching
---

Matching, borrowing, and references.

Pull from [my post](https://stackoverflow.com/questions/57128842/how-are-tuples-destructured-into-references/57128935#57128935)
and possibly [my other post](https://stackoverflow.com/questions/56957770/how-are-tuples-inside-of-arcs-destructured-with-references).

TODO Research error: cannot move out of borrowed content.
Update: I think I have this now.
TODO remove `println!()` from examples. It coerces values.

We have a reference to an `Option`. We're trying to dereference this,
which either copies or moves the value behind the reference? I don't know.
I guess it tries to move, but it can't because this is on the heap.
Play with this.

TODO apply to tuples?


## Source

On GitHub.


## Copy Types

These are easier - they're on the stack.
Always copied, no ownership to worry about.

`Some` type in an `Option`:

```rust
let maybe_number = Some(42);
match maybe_number {
    Some(x) => println!("Found a specific value: {}", x),
    None => println!("Found nothing"),
}
```

`None` type in an `Option`:

```rust
// Must specify type - Rust can't deduce a type from None
let maybe_number: Option<i32> = None;
match maybe_number {
    Some(x) => println!("Found a specific value: {}", x),
    None => println!("Found nothing"),
}
```

TODO Add example of `Some(_)`?


## Non-Copy Types

Let's use a `Box`.
These are on the heap so we need to worry about ownership.


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

This works fine.
Using the value again fails to compile:

```rust
match maybe_number {
    Some(_) => {},
    None => {},
}
```

```
use of moved value: `maybe_number`
```


### Reference

Match on a reference


### Borrow

FIXME this seems lame. Try references first.

The `match` itself is actually performing a borrow.

Borrow using the `ref` pattern (is this recommended against?):

```rust
let maybe_number = Some(Box::new(42));
match maybe_number {
    Some(ref borrows_box) => {
        // Dereference borrow, then dereference Box
        let x = **borrows_box;
        println!("Found something: {}", x);
    },
    None => println!("Found nothing"),
}
```

Alternatively, use a `&`:

```rust
match &maybe_number {
    Some(borrows_box) => {
        // Dereference borrow, then dereference Box
        let x = **borrows_box;
        println!("Found something: {}", x);
    },
    None => println!("Found nothing"),
}
```

The double dereference must be done in-place to avoid a "move out of borrowed content" compiler error:

```rust
match &maybe_number {
    Some(borrows_box) => {
        let the_box = *borrows_box;     // <-- fails
        let x = *the_box;
        println!("Found something: {}", x);
    },
    None => println!("Found nothing"),
}
```


Both of these borrow, so we can match again (and in this case take ownership):

```rust
match maybe_number {
    Some(_) => {},
    None => {},
}
```


To avoid the double dereference, add a leading `&` to the patterns:




## Further Reading

  * [match ergonomics](https://github.com/rust-lang/rfcs/blob/master/text/2005-match-ergonomics.md)
  * [ergonomics?](https://blog.rust-lang.org/2017/03/02/lang-ergonomics.html)
