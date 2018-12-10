---
title: CMake Anti-Antipatterns
layout: post
tags: [cmake]
---

...what to do right. Find working source code
[at this dead link]() or check out
[the docs]().


## Why Anti-Antipatterns?

As with many tools, CMake has evolved over time. Adoption of new techniques is
not universal, so there are still many tutorials and products using
"the old way" - antipatterns.

This is a select list of "the new way" - modern practices (not antipatterns).
The antipatterns themselves are omitted; why add noise to the signal?


## CMake Best Practices

In general, operate on [targets](https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html#introduction).
This keeps effects localized - settings for one target won't unexpectedly
bleed over to others.


### Set Compiler Features

To specify compiler attributes (such as the language standard), use
[target_compile_features()](https://cmake.org/cmake/help/latest/prop_gbl/CMAKE_C_KNOWN_FEATURES.html#prop_gbl:CMAKE_C_KNOWN_FEATURES):
```cmake
target_compile_features(TARGET
    [PUBLIC/PRIVATE/INTERFACE]
    <feature>
)
```

This will translate the feature into the flag that is appropriate for the compiler.
These are complete lists of
[C features](https://cmake.org/cmake/help/latest/prop_gbl/CMAKE_C_KNOWN_FEATURES.html#prop_gbl:CMAKE_C_KNOWN_FEATURES)
and
[C++ features](https://cmake.org/cmake/help/latest/prop_gbl/CMAKE_CXX_KNOWN_FEATURES.html#prop_gbl:CMAKE_CXX_KNOWN_FEATURES).


### Set Include Flags

To add `-I` or `-isystem` flags, use [target_include_directories()](https://cmake.org/cmake/help/latest/command/target_include_directories.html#command:target_include_directories):
```cmake
target_include_directories(TARGET
    [PUBLIC/PRIVATE/INTERFACE]
    "path/to/directory"
)
```
This will pass `-Ipath/to/directory` to the preprocessor.


### Set Compile Definitions

To add `-D` flags, use
[target_compile_definitions()](https://cmake.org/cmake/help/latest/command/target_compile_definitions.html#command:target_compile_definitions):
```cmake
target_compile_definitions(TARGET
    [PUBLIC/PRIVATE/INTERFACE]
    OPTION
)
```

This will pass `-DOPTION` to the preprocessor. There is no need to add `-D`
yourself.


### Set Compile Options

To pass other compiler flags, use
[target_compile_options()](https://cmake.org/cmake/help/latest/command/target_compile_options.html#command:target_compile_options):
```cmake
target_compile_options(TARGET
    [PUBLIC/PRIVATE/INTERFACE]
        <flag>
)
```

For example,
```cmake
target_compile_options(TARGET
    PRIVATE -Wall
)
```
will pass `-Wall` to the compiler.


### Link Libraries

To link against a library, use
[target_link_libraries()](https://cmake.org/cmake/help/latest/command/target_link_libraries.html#command:target_link_libraries):
```cmake
target_link_libraries(TARGET
    [PUBLIC/PRIVATE/INTERFACE]
        <library::library>
)
```

If possible, specify the library using an
[alias target](https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html#alias-targets)
(using a `::`).
This allows CMake to throw a descriptive error while it is generating the build
system rather than waiting for the compiler to throw an error at link time.
Explanation [here](https://youtu.be/bsXLMQ6WgIk?t=1577).


## Resources

  * [GitBook Docs](https://cliutils.gitlab.io/modern-cmake/)
  * [Offical docs intro](https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html)
  * [Official docs index page](https://cmake.org/cmake/help/latest/)
  * Video of [Daniel Pfeiffer](https://youtu.be/bsXLMQ6WgIk)'s excellent talk at at C++Now 2017, with [slides](https://www.slideshare.net/DanielPfeifer1/effective-cmake)
  * Video of [Mathieu Ropert](https://youtu.be/eC9-iRN2b04) at CppCon 2017
  * A curated list of [awesome CMake](https://github.com/onqtam/awesome-cmake)
