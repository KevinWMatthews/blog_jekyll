---
title: &title "Destructuring Tuples in Rust"
permalink: /tuple-destructuring-in-rust/
excerpt: ""
toc: true
toc_label: *title
toc_sticky: true
categories:
  - rust
tags:
  - rust
  - boxes
  - ownership
---

TODO add intro

## Source

On GitHub.


## Tuple Refresher

Tuples are a collection individual elements in a single variable:

```rust
let the_tuple: (i32, i32, i32) = (1, 2, 3);
```

Individual elements are not named but can be accessed by index.

```rust
let x = the_tuple.0;
let y = the_tuple.1;
let z = the_tuple.2;
```

Rust can frequently infer the type, allowing a tuple assignment to be simplified:

```rust
let the_tuple = (1, 2, 3);
```


## Destructuring

Rust provides a shorthand syntax for retrieving all elements from a tuple and assigning them to local variables:

```rust
let the_tuple = (1, 2, 3);
let (x, y, z) = the_tuple;
```

This is called "tuple destructuring".


### Non-`Copy` Types

The previous example shows destructuring a `Copy` type.
In this case, ownership concerns are minimal because data is simply copied.

If a type does not implement the `Copy` trait, ownership must be considered:

```rust
let the_tuple = (Box::new(1), Box::new(2));

// Moves boxes out of tuple
let (box1, box2) = the_tuple;
let x = *box1;
let y = *box2;

// Can't use again - the Boxes were moved out of the tuple.
// let (box1, box2) = the_tuple;
```


## Destructuring with References

Rust allows the user to borrow data from a tuple while destructuring.
Instead of taking ownership, the destructured values can be declared as references.

In old Rust, this was done explicitly:

```rust
let the_tuple = (1, 2, 3);
let &(ref rx, ref ry, ref rz) = &the_tuple;
```

This takes a reference to the tuple and assignes it to individual references

New Rust uses [match ergonomics](https://github.com/rust-lang/rfcs/blob/master/text/2005-match-ergonomics.md) to simplify the syntax considerably:

```rust
let the_tuple = (1, 2, 3);
let (rx, ry, rz) = &the_tuple;
```

`Copy` types can easily be dereferenced and assigned to new variables.
Values are simply copied from the reference.

```rust
let x = *rx;
let y = *ry;
let z = *rz;
```

`Copy` types can easily be dereferenced and assigned to new variables.
Values are simply copied from the reference.

```rust
let x = *rx;
let y = *ry;
let z = *rz;
```


### Non-Copy Type

Non-`Copy` types typically borrow from the tuple to avoid invalidating the original tuple.

```rust
let the_tuple = (Box::new(1), Box::new(2));
let (box1, box2) = &the_tuple;
// let &(ref box1, ref box2) = &the_tuple;
```

Care must be taken when derefencing - assignment will try to move the value out of the tuple.
This gives a compiler error:

```rust
let x = *box1;
```
```
cannot move out of borrowed content
```

This is because `*box` dereferences the `&Box`, providing access to the underlying `Box`.
The `let` assignment then must move the `Box` into the new variable (the `Box` isn't `Copy`).
This isn't allowed, however; references only borrow and can not transfer ownership.

Instead of assigning the `Box`, access its inner value directly:
Care must be taken with the borrow checker.


### `Copy` Types

TODO probably remove this section?

Destructuring `Copy` types is straightforward.
There are no ownership concerns because data is simply copied.

```rust
#[derive(Copy, Clone)]
struct CopyType {
    data: i32,
}

let the_tuple = (
    CopyType {data: 1},
    CopyType {data: 2},
)

let (ct1, ct2) = the_tuple;
let x = ct1.data;
let y = ct2.data;

// Can still use the tuple
let (ct1, ct2) = the_tuple;
```
```rust
let x = **box1;
let y = **box2;
```

The first application of `*` dereferences the reference.
The second application of `*` accesses the inner of the `Box` using the `Deref` trait.


## Further Reading:

  * Rust's [match ergonomics RFC](https://github.com/rust-lang/rfcs/blob/master/text/2005-match-ergonomics.md)
  * [Stack Overflow post](https://stackoverflow.com/questions/57128842/how-are-tuples-destructured-into-references/57128935)
