---
title: &title "Rust: Lifetimes for References"
permalink: /rust-non-lexical-lifetimes-for-references/
excerpt: "Rust's unique scoping rules for references"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - rust
tags:
  - rust
  - lifetimes
  - ownership
---

Rust recently changed the behavior of the borrow checker by introducing [non-lexical lifetimes](https://doc.rust-lang.org/stable/edition-guide/rust-2018/ownership-and-lifetimes/non-lexical-lifetimes.html).


## Source

Find [source code](https://github.com/KevinWMatthews/rust-ownership) on GitHub.
For a similar example, see [this gist](https://gist.github.com/KevinWMatthews/bfd75c91adc6f23e8869992bd7c749c3).


## Background

Many languages, such as C, C++, Python, and Ruby, rely largely on lexical scoping.
Historically Rust was similar - it used lexical lifetimes for references, aligning it with the common languages above.
Rust now allows non-lexical lifetimes for references.
This can be counterintuitive at first, but it offers quite a bit of flexibility with Rust's borrow checker.


## Reference lifetimes


### Old Rust

In older Rust code, the lifetime of a reference lasts until the end of a block:

```rust
fn main() {
    let mut x = 5;

    let y = &x;     // <-- Lifetime of reference 'y' starts

    // Use the reference
    let val = *y;

    // Do other stuff
    // ...
} // <-- Lifetime of reference 'y' ends
```

This is a "lexical lifetime", if you will.
The reference is in scope until the end of the current lexical environment (here the block),
i.e. the reference goes out of scope with the block that contains it.


### New Rust

In newer Rust code, the lifetime of a reference *lasts through the last time it is used*:

```rust
fn main() {
    let mut x = 5;

    let y = &x;     // <-- Lifetime of reference 'y' starts

    // Use the reference
    let val = *y;   // <-- Lifetime of reference 'y' ends

    // Do other stuff
    // ...
}
```

This is a "non-lexical lifetime": the scope of the reference ends __before__ the end of the block!
The lexical unit continues but the compiler considers the reference to be out of scope.

If the reference is used again, its lifetime is extended:

```rust
fn main() {
    let mut x = 5;

    let y = &x;     // <-- Lifetime of reference 'y' starts

    // Use the reference
    let val = *y;

    // Do other stuff
    // ...

    // Use the reference again
    let val2 = *y;  // <-- Lifetime of reference 'y' ends
}
```

Rust must keep the reference in scope so that it can be used later.
Notice that the reference is in scope while the "other stuff" is executed.


## Mutable references

Non-lexical lifetimes have a large impact on mutable references.
Remember that Rust does not allow a mutable reference while any other reference is in scope.


### Old Rust

Older Rust code (and many online examples!) uses lexical lifetimes, so this is a compiler error:

```rust
fn main() {
    let mut x = 5;

    let y = &x;     // <-- Lifetime of reference 'y' starts

    // Compiler error!
    let z = &mut x; // <-- Lifetime of reference 'z' starts
} // <-- Lifetime of references 'y' and 'z' end
```

The borrow checker will not allow a mutable borrow while another borrow is in scope.

The only way to avoid having multiple simultaneous references is to introduce a new scope:

```rust
fn main() {
    let mut x = 5;

    {
        let y = &x; // <-- Lifetime of reference 'y' starts
    }               // <-- Lifetime of reference 'y' ends

    // 'y' is out of scope so we can safely borrow mutably
    let z = &mut x; // <-- Lifetime of reference 'z' starts
}
```

The extra block forces the immutable reference `y` out of scope so that `z` can be created safely.


### New Rust

Newer Rust code can leverage the fact that a reference goes out of scope at its last use:

```rust
fn main() {
    let mut x = 5;

    let y = &x;     // <--Lifetime of reference 'y' starts

    // Use the reference
    let val = *y;   // <-- Lifetime of reference 'y' ends

    // The compiler determines that 'y' is never used again,
    // so it considers 'y' to be out of scope.
    // We can safely borrow mutably.
    let z = &mut x;
}
```

The reference `y` ends at its last use so `z` can be created safely without any extra work.


## Gotchas

Beware of extending the lifetime of a reference!

Consider the previous example:

```rust
fn main() {
    let mut x = 5;

    let y = &x;     // <-- Lifetime of reference 'y' starts

    // Use the reference
    let val = *y;   // <-- Lifetime of reference 'y' ends

    let z = &mut x;
}
```

If we use the reference `y` again, we extend its lifetime:

```rust
fn main() {
    let mut x = 5;

    let y = &x;     // <-- Lifetime of reference 'y' starts

    // Use the reference
    let val = *y;

    // y still exists... compiler error!
    let z = &mut x;

    let val2 = *y;  // <-- Lifetime of reference 'y' ends
}
```

Now `y` and `z` exist simultaneously! Rust throws a compiler error.

Introducing a scope around `z` does not solve the issue:

```rust
fn main() {
    let mut x = 5;

    let y = &x; // <-- Lifetime of reference 'y' starts

    // Use the reference
    let val = *y;

    {
        // The new scope inherits y... compiler error!
        let z = &mut x;
    }

    // Use the reference again
    let val2 = *y;  // <-- Lifetime of reference 'y' now ends
}
```

The solution is to let `y` go out of scope and recreate it later:

```rust
fn main() {
    let mut x = 5;

    let y = &x;     // <-- Lifetime of reference 'y' starts

    // Use the reference
    let val = *y;   // <-- Lifetime of reference 'y' ends

    let z = &mut x;
    // Let reference 'z' go out of scope

    // Create a new reference
    let y = &x;     // <-- Lifetime of new reference 'y' starts
    let val2 = *y;  // <-- Lifetime of new reference 'y' ends

    // Do not use 'z' again! This would extend its scope.
}
```

Instead of using the existing reference `y`, create a new reference.
This allows the original reference to go out of scope before `z` is created.

Of course, one need not recreate `y`; any name will do.

Note that `z` can not be used after `y` is created again!
This would reintroduce the same problem.


## Further reading

Rust docs:

  * Non-lexical lifetimes in [rust-lang docs](https://doc.rust-lang.org/edition-guide/rust-2018/ownership-and-lifetimes/non-lexical-lifetimes.html)
  * Lifetimes in [Rust by Example](https://doc.rust-lang.org/rust-by-example/scope/lifetime.html)

Also see this post on:

  * [Stack Overflow](https://stackoverflow.com/questions/50251487/what-are-non-lexical-lifetimes)

For a visual representation of lifetimes, see:

  * [rufflewind](https://rufflewind.com/2017-02-15/rust-move-copy-borrow)
  * [adamant-lant](https://blog.adamant-lang.org/2019/rust-lifetime-visualization-ideas/)
