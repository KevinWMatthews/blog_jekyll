---
title: Hello, World in C
layout: post
tags: [c, cmake, docker, docker-compose]
---

...and an introduction to this blog.

## Sanity Check

Where is the code? How can I (actually you) run it?

Build systems can be complex even for a simple project, so I've handled the details.

[This project](https://github.com/KevinWMatthews/c-hello_world/) can be built
with CMake and gcc, docker, or docker-compose.
See [the docs](https://kevinwmatthews.github.io/c-hello_world/) to learn how.

The project is simple:

```c
#include <stdio.h>

int main(int argc, char *argv[])
{
    printf("Hello, World!\n");
    return 0;
}
```

to highlight the techniques used in the setup process.

Welcome and enjoy!
