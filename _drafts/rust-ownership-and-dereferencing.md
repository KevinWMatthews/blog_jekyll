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

A short exploration of Rust's compiler error:

> error[E0507]: cannot move out of borrowed content
> error[E0507]: cannot move out of `*<variable>` which is behind a `&` reference

## Source

On GitHub.


## Background

Assigning through a dereference causes issues.
This often happens while pattern matching, but it's easier to explore this separately.


## Copy Type

If a struct implements the `Copy` trait, we can dereference and assign at will.

Here is a basic Copyable type:

```rust
#[derive(Copy, Clone)]
struct CopyType {
    data: i32,
}

let copy_type = CopyType {
    data: 42,
};
```

Take a reference to this:

```rust
let copy_type_ref = &copy_type;
```

We can dereference and use the data:

```rust
let data = (*copy_type_ref).data;
```

Rust's `.` operator automatically dereferences (I think), so it's more idiomatic to use:

```rust
let data = copy_type_ref.data;
```

We can also dereference and assign:

```rust
let copy_type_deref = *copy_type_ref;
```

The dereference gives access to the underlying struct.
This struct is then copied in to the new variable using the `Copy` trait.


## Non-Copy Type

If a struct does not implement the `Copy` trait, dereferencing has caveats.

Here is a simplistic type that can not be copied:

```rust
struct NonCopyType {
    data: i32,
}
```

For simplicity, we've merely removed the `Copy` trait: `#[derive(Copy)]`.

Create a variable and a reference as before:

```rust
let non_copy_type = NonCopyType {
    data: 42,
};

let non_copy_type_ref = &non_copy_type;
```

We can dereference and use the data as before:

```rust
let data = non_copy_type_ref.data;
```

but dereferencing and assigning causes a compiler error:

```rust
let non_copy_type_deref = *non_copy_type_ref;
```

```
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

Actually two errors and a hint.

Let's unpack this. First, the hint:

> consider changing this to be a mutable reference: `&mut non_copy_type`

I don't know why Rust suggests this; it doesn't help.

The error messages are essentially identical:

> cannot move out of borrowed content
> cannot move out of `*non_copy_type_ref` which is behind a `&` reference

The first seems to be general, the second is very specific.

Why does Rust raise an error?
The answer is in the language: a reference borrows; it does not own.

The issue is the assignment; it needs to populate a variable.
The non-copy type can't be copied so it must be moved (transferring ownership).
This requires taking ownership of the underlying object, which isn't allowed from behind a borrow.
Why? The point of a borrow is that it does *not* own the object that it refers to.
A borrow can't transfer ownership because it doesn't own what it borrows.
Wouldn't that be stealing?

What's the solution?
Don't do that.


## Further Reading

  * [Stack Overflow](https://stackoverflow.com/questions/28258548/cannot-move-out-of-borrowed-content-when-trying-to-transfer-ownership)
  * [Reddit post](https://www.reddit.com/r/rust/comments/3dqq0l/why_does_dereferencing_here_involve_a_move/)
