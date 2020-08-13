---
type: article
date: 2020-08-13
url: /from-go-to-zig/
title: From Go to Zig
summary: Getting to know Zig, a general-purpose programming language and toolchain for maintaining robust, optimal, and reusable software.
---

My friend [Christine](https://christine.website/) has spoken well of
[Zig](https://ziglang.org/) for a while now, and my interest was peaked when I read
that it can [integrate with C libraries](https://ziglang.org/documentation/master/#cImport)
without the use of FFI/bindings.
In this article I will try to contrast Zig against my favorite language, [Go](https://golang.org/).

_(I will leave it to others to compare Zig with C++, D or Rust)_

--------------------------------------

## Similarities with Go...

Let’s start off by listing some of the characteristics shared between Go and Zig:

  - Ahead-of-time (AOT) compiled
  - Open Source
  - Statically typed
  - Cross-compilation
  - No operator overloading
  - Tool for **one** canonical code formatting style (`go fmt` and `zig fmt`)
  - Errors are values
  - WebAssembly as a compile target
  - Multiline string literals
  - There is no operator overloading
  - `defer`
  - Source code is encoded in UTF-8

## How is it different from Go?

> **Note:** These are just a few of the things I’ve picked up when reading about Zig.
I still have a lot to learn before I feel confident in using the language.

  - Build modes on scope level
  - [Zig Build System](https://ziglang.org/#Zig-Build-System)
  - Manual memory management
  - Algebraic data types (Union and Enum types!)
  - Optional type instead of null pointers
  - Can output tiny binaries
  - [Generics and compile-time code execution](https://andrewkelley.me/post/zig-programming-language-blurs-line-compile-time-run-time.html)
  - First-class support for **no** standard library
  - Somewhat easier to Google
  - ~zero overhead when calling out to C
  - “Zig is better at using C libraries than C is at using C libraries.”
  - Enforcing the handling of returned errors
  - Arbitrary bit-width integers (`i7` for example)
  - Undefined values
  - Thread local variables
  - No multiline comments

## [Zen](https://ziglang.org/documentation/master/#Zen) of Zig

  - Communicate intent precisely.
  - Edge cases matter.
  - Favor reading code over writing code.
  - Only one obvious way to do things.
  - Runtime crashes are better than bugs.
  - Compile errors are better than runtime crashes.
  - Incremental improvements.
  - Avoid local maximums.
  - Reduce the amount one must remember.
  - Minimize energy spent on coding style.
  - Resource deallocation must succeed.
  - Together we serve end users.

## Installing Zig

If you are using **macOS** and have [Homebrew](https://brew.sh/)
installed, then you can install Zig like this:

```bash
$ brew install zig
```

The current version of `zig` as of this writing is **0.6.0**.

Make sure you also get [zig.vim](https://github.com/ziglang/zig.vim).

## Hello, World!

The entry point of a Zig binary is the `main` fn.
The binary is named after the `.zig` file.

**zighello/zighello.zig**
```c
const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().outStream();
    try stdout.print("Hello, {}!\n", .{"world"});
}
```

This can be compiled with `zig build-exe zighello.zig --release-small --strip --single-threaded` and results in a `~10 KB` static executable.

(Not strictly true that you get a static executable under macOS, it is linked to `libSystem.B.dylib`)

And as you probably know, the Go entry point is the `main` func.

**gohello/main.go**
```go
package main

import "fmt"

func main() {
	fmt.Println("Hello, World!")
}
```

This can be compiled with `go build -ldflags "-s -w" -trimpath main.go` and results in a `~1.7 MB` executable (when using Go version `1.14.7` under macOS)

> **Note:** The size of your binaries doesn’t matter in most cases, but sometimes it matters a lot, for example when compiling to [WebAssembly](https://webassembly.org/)

## Learn more about Zig

  - [The Zig Programming Language](https://ziglang.org/)
  - [Ziglearn](https://ziglearn.org/)
  - [/r/Zig](https://www.reddit.com/r/Zig/)
  - [Andrew Kelley](https://andrewkelley.me/)
    - [`zig cc`: a Powerful Drop-In Replacement for GCC/Clang](https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html)

## Bonus: Linking to the shared library from the article [Go and Ruby-FFI](/go-and-ruby-ffi/)

An example of importing a shared library from Zig, using the `@cInclude` feature:

```c
const std = @import("std");

const c = @cImport({
    @cInclude("libsum.h");
});

pub fn main() void {
    const sum: i64 = c.add(4, 2);

    std.debug.warn("{}\n", .{sum});
}
```

Then you can compile this by calling `zig -isystem . --library ./libsum.so build-exe zigsum.zig`

> Captain: Take off every 'ZIG'!!
