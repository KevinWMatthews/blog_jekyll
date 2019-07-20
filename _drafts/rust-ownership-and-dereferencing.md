---
title: &title "Ownership and Dereferencing in Rust"
permalink: /rust-ownership-and-dereferencing/
excerpt: "Dereferencing and Rust's compiler error \"cannnot move out of borrowed content\""
toc: true
toc_label: *title
toc_sticky: true
categories:
  - rust
tags:
  - rust
  - ownership
---

A short exploration of Rust's compiler errors:

> error[E0507]: cannot move out of borrowed content

> error[E0507]: cannot move out of `*some_reference` which is behind a `&` reference


## Source

Find [source code](https://github.com/KevinWMatthews/rust-ownership) on GitHub.


## Background

This error can easily happen while pattern matching, but it's easier to explore the fundamental issue separately.

The root of the problem is creating a new variable by dereferencing:

```rust
let some_reference = &some_variable;
let new_variable = *some_reference;
```

This is not allowed;
`some_reference` can not transfer ownership to a `new_variable` because the reference borrows (and does not own) the underlying value.


## Copy Type

First let's explore `Copy` types.
If a struct implements the `Copy` trait, we can dereference and assign at will.
This will not cause a compiler error because ownership is not transfered; instead, data is copied.

Define a basic `Copy`able type:

```rust
#[derive(Copy, Clone)]
struct CopyType {
    data: i32,
}
```

Create a variable and borrow it:

```rust
let copy_type = CopyType {
    data: 42,
};
let copy_type_ref = &copy_type;
```

We can dereference and assign:

```rust
let copy_type_deref = *copy_type_ref;
```

The dereference gives access to the underlying struct.
This struct is then copied in to the new variable by virtue of the `Copy` trait.

We can also dereference and use the data:

```rust
let data = (*copy_type_ref).data;
```

Rust's `.` operator automatically dereferences (courtesy of the `Deref` trait?),
so it's more idiomatic to use:

```rust
let data = copy_type_ref.data;
```


## Non-Copy Type

If a struct does not implement the `Copy` trait, one must dereference with care.

Define a type that can not be copied:

```rust
struct NonCopyType {
    data: i32,
}
```

For simplicity we've merely removed the `Copy` trait: `#[derive(Copy)]`.
(There is nothing inherently un-copyable about this struct).

Create a variable and borrow it as before:

```rust
let non_copy_type = NonCopyType {
    data: 42,
};

let non_copy_type_ref = &non_copy_type;
```

We can dereference and use the data just as with `Copy` types:

```rust
let data = non_copy_type_ref.data;
```

but dereferencing and assigning causes a compiler error:

```rust
let non_copy_type_deref = *non_copy_type_ref;
```

```
error[E0507]: cannot move out of borrowed content
|     let non_copy_type_deref = *non_copy_type_ref;
|                               ^^^^^^^^^^^^^^^^^^
|                               |
|                               cannot move out of borrowed content
|                               help: consider removing the `*`: `non_copy_type_ref`

error[E0507]: cannot move out of `*non_copy_type_ref` which is behind a `&` reference
|
|     let non_copy_type_ref = &non_copy_type;
|                             -------------- help: consider changing this to be a mutable reference: `&mut non_copy_type`
...
|     let non_copy_type_deref = *non_copy_type_ref;
|                               ^^^^^^^^^^^^^^^^^^
|                               |
|                               cannot move out of `*non_copy_type_ref` which is behind a `&` reference
|                               `non_copy_type_ref` is a `&` reference, so the data it refers to cannot be moved
```

Actually, Rust gives two errors and a hint.

Let's unpack this. First, the hint:

> consider changing this to be a mutable reference: `&mut non_copy_type`

Don't bother; this doesn't help. (I don't yet know why Rust suggests this).

The error messages are essentially identical:

> cannot move out of borrowed content

> cannot move out of `*non_copy_type_ref` which is behind a `&` reference

The first seems to be general, the second is very specific.

Why does Rust raise an error?
The answer is in the verbiage: a reference borrows and does not own.

The issue is the assignment.
Assignments must own data so that they can store it in the new variable.
`Copy` types simply copy the data and thereby own it.
Non-`Copy` types can't do this; they must move data, transferring ownership from the old variable to the new.

This transfer of ownership causes the error - ownership transfer is not allowed from behind a borrow.
Why? Think of what a borrow is: it does *not* own the object that it refers to.
A borrow can't transfer ownership because it doesn't own what it borrows.
Wouldn't that be stealing?


## Summary

Rust does not allow references to non-`Copy` types to transfer ownership:

```rust
let reference = &non_copy_type;
let variable = *reference;
```

The reference does not own the referent and therefore can not to transfer ownership of the referent.

What's the solution?
Don't do that.


## Further Reading

Dereferencing and assignment:

  * [Stack Overflow post](https://stackoverflow.com/questions/28258548/cannot-move-out-of-borrowed-content-when-trying-to-transfer-ownership)
  * [Reddit post](https://www.reddit.com/r/rust/comments/3dqq0l/why_does_dereferencing_here_involve_a_move/)
  * [Stack Overflow search](https://stackoverflow.com/search?q=%5Brust%5D+move+out+of+borrowed+content+is%3Aq)

Auto-dereferencing during struct member access:

  * [Stack Overflow post](https://stackoverflow.com/questions/44117951/why-does-accessing-a-field-on-a-pointer-to-a-struct-work-in-rust)
