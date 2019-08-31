---
title: &title "Iterators in Rust"
permalink: /iterators-in-rust/
excerpt: ""
toc: true
toc_label: *title
toc_sticky: true
categories:
  - rust
tags:
  - rust
  - iterators
---

Several things to look at:

  * `into_iter()`
  * `iter()`
  * `iter_mut()`

Also,

  * `IntoIterator`
  * `Iterator`


## Ideas

`iter()` -> Create an iterator that borrows the items from the collection.

`into_iter()` -> Convert the collection into an iterator.
Can be consuming (by move) or non-consuming (by reference).


## `IntoIterator`

This is a trait: [`std::iter::IntoIterator`](https://doc.rust-lang.org/std/iter/trait.IntoIterator.html).

The `IntoIterator` trait requires the `into_iter()` method.
This is a generic method to obtain an iterator.
This resulting iterator may yield values, immutable references, or mutable references depending on the context (see this [Stack Overflow Post](https://stackoverflow.com/questions/34733811/what-is-the-difference-between-iter-and-into-iter/34745885#34745885)).

This be implemented directly on a collection (a consuming iterator) or on a reference to a collection (a non-consuming iterator).


## `Iterator`

This is a trait: [`std::iter::Iterator`](https://doc.rust-lang.org/std/iter/trait.Iterator.html).

`iter()` is also a method to obtain an iterator.
It is not required by a trait, but many types implement it by convention (?).
By convention, this will yield a reference to the items (see this [Stack Overflow Post](https://stackoverflow.com/questions/34733811/what-is-the-difference-between-iter-and-into-iter/34745885#34745885)).

The `Iterator` trait requires the `next()` method.


### Example Implementation: `vec`

For a:

  * [`into_iter()`, consuming iterator](https://doc.rust-lang.org/src/alloc/vec.rs.html#1801-1838)
  * [`into_iter()`, reference](https://doc.rust-lang.org/src/alloc/vec.rs.html#1841-1848)
  * [`into_iter()`, mutable reference](https://doc.rust-lang.org/src/alloc/vec.rs.html#1851-1858)
  * [`iter()`](https://doc.rust-lang.org/src/core/slice/mod.rs.html#522-539)


## Further Reading

Rust docs:

  * [`std::iter` module](https://doc.rust-lang.org/stable/std/iter/)
  * [`Iterator` trait](https://doc.rust-lang.org/std/iter/trait.Iterator.html)
  * [`IntoIterator` trait](https://doc.rust-lang.org/std/iter/trait.IntoIterator.html)

Stack Overflow:

  * [Example iterator](https://stackoverflow.com/questions/30218886/how-to-implement-iterator-and-intoiterator-for-a-simple-struct)
  * [Difference between `iter()` and `into_iter()`](https://stackoverflow.com/questions/34733811/what-is-the-difference-between-iter-and-into-iter)
  * [Properly implementing an iterable structure](https://stackoverflow.com/questions/54379841/how-to-properly-implement-iterable-structure-in-rust)

Misc:

  * Rust by Example: [`Iterator::any`](https://doc.rust-lang.org/stable/rust-by-example/fn/closures/closure_examples/iter_any.html)
  * Blog post: [effectively using iterators](https://hermanradtke.com/2015/06/22/effectively-using-iterators-in-rust.html)
