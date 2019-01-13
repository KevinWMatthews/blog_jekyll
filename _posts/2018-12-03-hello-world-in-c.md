---
title: Hello, World in C
permalink: /c-hello-world/
categories:
  - C
tags:
  - c
  - cmake
  - docker
---

...and an introduction to this blog. Find working source code
[on GitHub](https://github.com/KevinWMatthews/c-hello_world/) or check out
[the docs](https://kevinwmatthews.github.io/c-hello_world/).


## Sanity Check

Where is the code? How can I (actually you) run it?

This is a small application to help you get up and running.
It can be compiled using a
[Docker container](https://kevinwmatthews.github.io/c-hello_world/docker.html)
 or with your system's
 [CMake and gcc](https://kevinwmatthews.github.io/c-hello_world/system-tools.html).

The code is simple to allow us to focus on the build process:
```c
#include <stdio.h>

int main(int argc, char *argv[])
{
    printf("Hello, World!\n");
    return 0;
}
```

Take a look at
[the source](https://github.com/KevinWMatthews/c-hello_world/) and
[the docs](https://kevinwmatthews.github.io/c-hello_world/)
to learn how it works. Enjoy!
