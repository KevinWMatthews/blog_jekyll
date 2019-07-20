---
title: &title "Heap allocation in Rust: Boxes"
permalink: /heap-allocation-in-rust-with-boxes/
excerpt: "Working with Rust's Boxes"
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

Allocating on the heap.

## Source

On GitHub.


## `Drop` Trait

Implements the `Drop` trait - memory is automatically freed.

```rust
fn drop_trait() {
    let the_box = Box::new(42);
} // <-- memory is freed here
```

## `Deref` Trait

Implements the `Deref` trait - can use `*` to get the inner value.

```rust
fn deref_trait() {
    let the_box = Box::new(42);
    let value = *the_box;
}
```


## `Debug` Trait

Implements the `Debug` trait - can print the contents using `{:?}`.

```rust
fn debug_trait() {
    let the_box = Box::new(42);
    println!("The box: {:?}", the_box);
}
```


## Can not assign from borrow

Can't move from behind a reference - borrow does not own:

```rust
fn no_move() {
    let the_box = Box::new(42);
    let the_box_ref = &the_box;
    let now_the_box = *the_box_ref;
}
```


## Can get value from reference

Must do double-dereference (`**`) to get the value from a reference to a `Box`.

```rust
fn get_value() {
    let the_box = Box::new(42);
    let the_box_ref = &the_box;
    let value = **the_box_ref;

    // Not allowed - can not move from behind a borrow
    // let new_box = *the_box_ref;
    // let value = *new_box;
}
```

Deref coercion: can pass a `Box` to a function that takes a reference to the `Box`'s inner value:
```rust
let the_box: <Box<i32>> = Box::new(42);
func(&the_box);

fn func(x: &i32) {}
```
