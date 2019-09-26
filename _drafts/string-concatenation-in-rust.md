---
title: &title "String Concatenation in Rust"
permalink: /string-concatenation-in-rust/
excerpt: "The \"do\"s and \"don't\"s of joining strings in Rust"
toc: true
toc_label: *title
toc_sticky: true
categories:
  - rust
tags:
  - rust
  - strings
  - concatenation
---

Working with Rust's two string types, `&str` and `String`, to compose new strings.


## Source Code

Find source code [on GitHub]().
Also see runnable examples in [this gist](https://gist.github.com/KevinWMatthews/95a02f466f64424957c154008eb2922e).


## Data Types

Rust uses two data types to represent strings:

  * the string primitive (string slice), [`str`](https://doc.rust-lang.org/std/primitive.slice.html)
  * the standard library struct, [`String`](https://doc.rust-lang.org/std/string/struct.String.html
)

The `str` primitive is a [slice](https://doc.rust-lang.org/std/slice/index.html), a window into an existing collection. It is essentially a pointer and a length.

A `String` struct is a heap-allocated object. It can be modified as the string is updated.

`str` slices are (almost?) always borrowed and appear as `&str`.
`String` structs are dynamically allocated structs and, as with any other struct, can be borrowed or owned.


## Concatenation

### Recommended

The Rust community seems to recommend using either:

  * the [`format!`](https://doc.rust-lang.org/std/macro.format.html) macro from `std::format` to create a new `String`
  * the [`push_str()`](https://doc.rust-lang.org/std/string/struct.String.html#method.push_str) method to append to an existing `String`


### Alternatives

`String` [implements the `Add<&str>` trait](https://doc.rust-lang.org/std/string/struct.String.html#impl-Add%3C%26%27_%20str%3E), so a `String` can be concatenated with a `&str`:

```rust
let one = String::from("one");
let two = String::from("two");
let slice_two: &str = &two;
let three = one + slice_two;
// "onetwo"
```

`String` also [implements the `Deref` trait](https://doc.rust-lang.org/std/string/struct.String.html#impl-Deref), so a `&String` will be coerced into a `&str` and can then be concatenated:

```rust
let one = String::from("one");
let two = String::from("two");
let borrow_two: &str = &two;
let three = String::from(one + borrow_two);
// "onetwo"
```

However, these tend to be [recommended *against*](#recommended) in favor of `format!` or `push_str()`.


### Unsupported

`String` [does not implement the `Add<String>` trait](https://doc.rust-lang.org/std/string/struct.String.html#implementations), so two `String`s *can not* be concatenated:

```rust
let one = String::from("One");
let two = String::from("Two");
// Compiler error:
// Expected &str, found String
let three = one + two;
```

Implementing `Add<String>` for `String` has been a [topic of discussion](https://internals.rust-lang.org/t/implement-add-for-string-string/4088)
but has not been done.

Rust can concatenate `String` with `&str`, so the compiler suggests that the second string be borrowed.

`str` [does not implement](https://doc.rust-lang.org/std/primitive.str.html#implementations) the `Add<&str>` trait for any type, so nothing can be concatenated with a `&str`:

```rust
let one = String::from("one");
let two = String::from("two");
let slice_one: &str = &one;

// Compiler error:
// `+` cannot be used to concatenate a `&str` with a `String`
let three = slice_one + two;

// Compiler error:
// `+` cannot be used to concatenate two `&str` strings
// (The String is coerced into a &str)
let three = slice_one + &two;

// Compiler error:
// `+` can not be used to concatenate two `&str` string
let slice_two: &str = &two;
let three = slice_one + slice_two;
```

## Links

  * the string primitive, [`str`](https://doc.rust-lang.org/std/primitive.slice.html)
  * the standard library struct, [`String`](https://doc.rust-lang.org/std/string/struct.String.html)
  * the [`format!`](https://doc.rust-lang.org/std/macro.format.html) macro
