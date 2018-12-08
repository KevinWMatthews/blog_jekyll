---
title: Hello, World in C
layout: post
tags: [c, cmake, docker]
---

...and an introduction to this blog.

## Sanity Check

Where is the code? How can I (actually you) run it?

[This application](https://github.com/KevinWMatthews/c-hello_world/) can help
us get up and running:

```c
#include <stdio.h>

int main(int argc, char *argv[])
{
    printf("Hello, World!\n");
    return 0;
}
```

The code is simple to allow us to focus on the build process.
Build systems can be complex even for a simple project, but I've handled the details.

Take a [look at the docs](https://kevinwmatthews.github.io/c-hello_world/)
to learn how it works, and enjoy!
